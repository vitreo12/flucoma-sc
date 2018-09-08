FDNMF {
	*process { arg server,  srcBuf, startAt = 0, nFrames = -1,startChan = 0,nChans = -1, dstBuf, dictBuf, dictFlag = 0, actBuf, actFlag = 0, rank = 1, iterations = 100, sortFlag = 0, windowSize = 1024, hopSize = 256, fftSize = -1, windowType = 0, randomSeed = -1;

		var dstBufNum,dictBufNum,actBufNum;

		if(srcBuf.bufnum.isNil) { Error("Invalid buffer").format(thisMethod.name, this.class.name).throw};

		server = server ? Server.default;

		dstBufNum = 	if(dstBuf.isNil, -1, {dstBuf.bufnum});
		dictBufNum = if(dictBuf.isNil, -1, {dictBuf.bufnum});
		actBufNum = 	if(actBuf.isNil, -1, {actBuf.bufnum});

		server.sendMsg(\cmd, \BufNMF, srcBuf.bufnum, startAt, nFrames, startChan, nChans, dstBufNum, dictBufNum, dictFlag, actBufNum, actFlag, rank, iterations, windowSize, hopSize,fftSize);
	}
}