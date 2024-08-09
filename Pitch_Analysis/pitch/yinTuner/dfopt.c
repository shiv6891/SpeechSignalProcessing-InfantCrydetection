/*
 * dfopt.c
 * Calculates the difference function (d)
 * of the given sequence (x) for all t=0:hop:tmax.
 * DF is based on EqA1 and optimized according to sec.V (YIN paper).
 *
 * The calling syntax is:
 *
 *		d = dfopt(x,W,hop)
 *
 * This is a MEX-file for MATLAB.
 *
 * Copyright (c) 2015 Dalatsis Antonios
 * ICSD, University of the Aegean
*/

#include "mex.h"


/*** computational routine ***********************************************/
void compute(double *x, double *d, int m, int n, int hop){
    int i,j,lt,rt,x1,x2,xstop,k;
    double s,a,d1;
    
    lt=rt=(int)((m+1)*0.5);
    
    //mexPrintf("Win=%d hop=%d lt=%d rt=%d n=%d\n",m,hop,lt,rt,n);
    
    for (i=0; i<m; i++){
        if (i&1) {rt++;} else {lt--;}
        for (j=0; j<n; j++){
            s=0;
            x1=lt+j*hop;
            x2=rt+j*hop;
            xstop=x1+hop;
            while (x1<xstop){
                a=x[x1]-x[x2];
                s+=a*a;
                x1++; x2++;
            }
            d[j*m+i]=s;
        }
    }
    
    k=m/hop-1;
    for (i=0; i<m; i++){
        s=0;
        for (j=0; j<k; j++)
            s+=d[j*m+i];
        x1=0; x2=k;
        while (x2<n){
            d1=d[x1*m+i];
            s+=d[x2*m+i];
            d[x1*m+i]=s;
            s-=d1;
            x1++; x2++;
        }
    }
}


/*** gateway routine *****************************************************/
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    double *inVector;       // input vector
    int wsize;              // input window size
    int nhop;               // input hop
    double *outMatrix;      // output matrix
    int xsize;              // length of input vector
    int dcols;              // row size of output matrix
    
    /* Verify Input and Output Parameters */
    if(nrhs!=3){
        mexErrMsgTxt("Three inputs required.");
    }
    if(nlhs!=1){
        mexErrMsgTxt("One output required.");
    }
    if(mxGetM(prhs[0])!=1) {
        mexErrMsgTxt("Input must be a row vector.");
    }
    if( !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) || mxGetNumberOfElements(prhs[1])!=1 ) {
        mexErrMsgTxt("Input wsize must be a scalar.");
    }
    if( !mxIsDouble(prhs[2]) || mxIsComplex(prhs[2]) || mxGetNumberOfElements(prhs[2])!=1 ) {
        mexErrMsgTxt("Input hop must be a scalar.");
    }
    
    /* Read Input Data */
    inVector = mxGetPr(prhs[0]);
    xsize = mxGetN(prhs[0]);
    wsize = (int)mxGetScalar(prhs[1]);
    nhop = (int)mxGetScalar(prhs[2]);
    
    if(xsize < 2*wsize){ mexErrMsgTxt("Not enougth data in x."); }
    
    /* Prepare Output Data */
    dcols=(int)((xsize-wsize)/nhop + 0.5);
    plhs[0] = mxCreateDoubleMatrix(wsize,dcols,mxREAL);
    outMatrix = mxGetPr(plhs[0]);
    
    /* Perform Calculation */
    compute(inVector,outMatrix,wsize,dcols,nhop);
    
    mxSetN(plhs[0],(int)(xsize-2*wsize)/nhop+1);  //new size
}
