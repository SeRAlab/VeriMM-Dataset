`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C;
    reg CE;
    reg CINVCTRL;
    reg CLKIN;
    reg [4:0] CNTVALUEIN;
    reg INC;
    reg LD;
    reg LDPIPEEN;
    reg ODATAIN;
    reg REGRST;
    wire [4:0] CNTVALUEOUT;
    wire DATAOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CE(CE),
        .CINVCTRL(CINVCTRL),
        .CLKIN(CLKIN),
        .CNTVALUEIN(CNTVALUEIN),
        .INC(INC),
        .LD(LD),
        .LDPIPEEN(LDPIPEEN),
        .ODATAIN(ODATAIN),
        .REGRST(REGRST),
        .CNTVALUEOUT(CNTVALUEOUT),
        .DATAOUT(DATAOUT)
    );
    task wait_cycles;

        input integer cycles;
        begin
            repeat(cycles) @(posedge C);
            #1;
        end
        endtask

    task init_signals;

        begin
            C = 0;
            CE = 0;
            CINVCTRL = 0;
            CLKIN = 0;
            CNTVALUEIN = 5'b00000;
            INC = 0;
            LD = 0;
            LDPIPEEN = 0;
            ODATAIN = 0;
            REGRST = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Default State", test_num);
            init_signals();


            REGRST = 1;
            wait_cycles(2);
            REGRST = 0;
            wait_cycles(1);


            #1;



            check_outputs(5'b00000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load CNTVALUEIN", test_num);
            init_signals();


            REGRST = 1;
            wait_cycles(1);
            REGRST = 0;


            CNTVALUEIN = 5'b11111;
            LD = 1;
            wait_cycles(1);
            LD = 0;
            wait_cycles(1);


            #1;



            check_outputs(5'b11111, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment Counter", test_num);
            init_signals();


            REGRST = 1;
            wait_cycles(1);
            REGRST = 0;


            CNTVALUEIN = 5'd10;
            LD = 1;
            wait_cycles(1);
            LD = 0;


            CE = 1;
            INC = 1;
            wait_cycles(1);
            CE = 0;
            wait_cycles(1);


            #1;



            check_outputs(5'd11, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement Counter", test_num);
            init_signals();


            REGRST = 1;
            wait_cycles(1);
            REGRST = 0;


            CNTVALUEIN = 5'd10;
            LD = 1;
            wait_cycles(1);
            LD = 0;


            CE = 1;
            INC = 0;
            wait_cycles(1);
            CE = 0;
            wait_cycles(1);


            #1;



            check_outputs(5'd9, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Pass-through", test_num);
            init_signals();


            REGRST = 1;
            wait_cycles(1);
            REGRST = 0;


            ODATAIN = 1;
            wait_cycles(1);


            #1;



            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over Load", test_num);
            init_signals();


            REGRST = 1;
            CNTVALUEIN = 5'd25;
            LD = 1;
            wait_cycles(1);


            #1;



            check_outputs(5'd0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [4:0] expected_CNTVALUEOUT;
        input expected_DATAOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CNTVALUEOUT === (expected_CNTVALUEOUT ^ CNTVALUEOUT ^ expected_CNTVALUEOUT) &&
                expected_DATAOUT === (expected_DATAOUT ^ DATAOUT ^ expected_DATAOUT)) begin
                $display("PASS");
                $display("  Outputs: CNTVALUEOUT=%h, DATAOUT=%b",
                         CNTVALUEOUT, DATAOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CNTVALUEOUT=%h, DATAOUT=%b",
                         expected_CNTVALUEOUT, expected_DATAOUT);
                $display("  Got:      CNTVALUEOUT=%h, DATAOUT=%b",
                         CNTVALUEOUT, DATAOUT);
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

endmodule
