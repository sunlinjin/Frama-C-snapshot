
int t[5]={0};
int u[5]={1,1,1,1,1};
int v[7]={1,1,1,1,1,1,1};
int w[7]={0};
char x[5]={0};

void main(int c)
{
  if (c)
    {
      ((char*)t)[6]='a';
      ((char*)u)[6]='c';
      *((short*)((char*)v+6))=27;
      *((short*)((char*)w+6))=57;
    }
  else
    {
      ((char*)t)[6]='b';
      ((char*)u)[6]='d';
      *((short*)((char*)v+7))=29;
      *((short*)((char*)w+7))=59;
      x[0]=1;
      x[1]=0;
      x[2]=1;
    }
}
