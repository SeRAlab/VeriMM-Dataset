`timescale 1ns/1ps

module eth_random_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] ByteCnt;
    reg MTxClk;
    reg [15:0] NibCnt;
    reg Reset;
    reg [3:0] RetryCnt;
    reg StateJam;
    reg StateJam_q;
    wire RandomEq0;
    wire RandomEqByteCnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_random dut (
        .ByteCnt(ByteCnt),
        .MTxClk(MTxClk),
        .NibCnt(NibCnt),
        .Reset(Reset),
        .RetryCnt(RetryCnt),
        .StateJam(StateJam),
        .StateJam_q(StateJam_q),
        .RandomEq0(RandomEq0),
        .RandomEqByteCnt(RandomEqByteCnt)
    );

    // Clock generation (10ns period)
    initial begin
        MTxClk = 0;
        forever #5 MTxClk = ~MTxClk;
    end

        task reset_dut;

        begin
            Reset = 1;
            StateJam = 0;
            StateJam_q = 0;
            RetryCnt = 0;
            NibCnt = 0;
            ByteCnt = 0;
            @(posedge MTxClk);
            #1;
            Reset = 0;
            @(posedge MTxClk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Latching Non-Zero LFSR value", test_num);
            reset_dut();

            RetryCnt = 4'd10;

            repeat(3) @(posedge MTxClk);


            StateJam = 1;
            StateJam_q = 1;
            @(posedge MTxClk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Byte Count Match", test_num);
            reset_dut();

            RetryCnt = 4'd10;
            repeat(3) @(posedge MTxClk);

            StateJam = 1;
            StateJam_q = 1;
            ByteCnt = 10'd7;
            NibCnt = 16'h007F;

            @(posedge MTxClk);
            #2;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Retry Counter Masking", test_num);
            reset_dut();

            RetryCnt = 4'd2;
            repeat(4) @(posedge MTxClk);

            StateJam = 1;
            StateJam_q = 1;
            ByteCnt = 10'd2;
            NibCnt = 16'h007F;

            @(posedge MTxClk);
            #2;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: NibCnt Boundary Condition", test_num);
            reset_dut();

            RetryCnt = 4'd10;
            repeat(3) @(posedge MTxClk);

            StateJam = 1;
            StateJam_q = 1;
            ByteCnt = 10'd7;
            NibCnt = 16'h007E;

            @(posedge MTxClk);
            #2;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eth_random Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_RandomEq0;
        input expected_RandomEqByteCnt;
        begin
            if (expected_RandomEq0 === (expected_RandomEq0 ^ RandomEq0 ^ expected_RandomEq0) &&
                expected_RandomEqByteCnt === (expected_RandomEqByteCnt ^ RandomEqByteCnt ^ expected_RandomEqByteCnt)) begin
                $display("PASS");
                $display("  Outputs: RandomEq0=%b, RandomEqByteCnt=%b",
                         RandomEq0, RandomEqByteCnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RandomEq0=%b, RandomEqByteCnt=%b",
                         expected_RandomEq0, expected_RandomEqByteCnt);
                $display("  Got:      RandomEq0=%b, RandomEqByteCnt=%b",
                         RandomEq0, RandomEqByteCnt);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ByteCnt, MTxClk, NibCnt, Reset, RetryCnt, StateJam, StateJam_q, RandomEq0, RandomEqByteCnt);
    end

endmodule
