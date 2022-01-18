/**
 * Created by DAEU on 2022-01-14.
 */

public class GetLongestString {

    public void getLogestString(List<String> nameList, Integer testNum){
        Map<String, Integer> mNameLength = new Map<String, Integer>();

        for(String name : nameList){
            // mapping key=name, value=name length
            mNameLength.put(name, name.length());
            System.debug('name: ' + name + '/ length: ' + name.length());
        }

        // get name length & sorting
        List<Integer> nameLength = mNameLength.values();
        nameLength.sort();

        // find max length of names
        Integer maxLength = nameLength[nameLength.size() - 1];
        List<String> maxNames = new List<String>();
        for(String name : mNameLength.keySet()){
            if(mNameLength.get(name) == maxLength){
                maxNames.add(name);
            }
        }

        String sName = '';
        sName = maxNames[0];
        // max name is multiful
        if(maxNames.size() > 1){
            for(Integer i = 1; i < maxNames.size(); i++){
                sName += ', ' + maxNames[i];
            }
        }

        testNum++;
        System.debug('longestNames('+ testNum +'): (' + sName + ')');
    }

    private void testFun(){
        // test1
        List<String> testNameList1 = new List<String>();

        testNameList1.add('Maltese');
        testNameList1.add('Pomeranian');
        testNameList1.add('Poodle');
        testNameList1.add('Shih Tzu');
        testNameList1.add('Bichon Frise');

        Integer testNum = 0;
        getLogestString(testNameList1, testNum++);

        //test2
        List<String> testNameList2 = new List<String>();

        testNameList2.add('seungmi.sung');
        testNameList2.add('jiwon.hong');
        testNameList2.add('jaewon.choi');
        testNameList2.add('hyein.jeon');
        testNameList2.add('sungjin.han');
        testNameList2.add('hyunsoo.song');
        testNameList2.add('yeonlim.jeong');
        testNameList2.add('yeonjun.kim');
        testNameList2.add('jieun.lee');
        testNameList2.add('won.suh');
        testNameList2.add('changjoo.sohn');

        getLogestString(testNameList2, testNum++);
    }
}