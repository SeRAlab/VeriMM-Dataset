`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg Req1;
    reg Req2;
    reg Req3;
    reg clk;
    reg reset;
    wire Grant1;
    wire Grant2;
    wire Grant3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .Req1(Req1),
        .Req2(Req2),
        .Req3(Req3),
        .clk(clk),
        .reset(reset),
        .Grant1(Grant1),
        .Grant2(Grant2),
        .Grant3(Grant3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Req1 = 0;
            Req2 = 0;
            Req3 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Req1 only", test_num);
            reset_dut();
            Req1 = 1; Req2 = 0; Req3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Req2 only", test_num);
            reset_dut();
            Req1 = 0; Req2 = 1; Req3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Req3 only", test_num);
            reset_dut();
            Req1 = 0; Req2 = 0; Req3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Req1 and Req2 (Priority Req1)", test_num);
            reset_dut();
            Req1 = 1; Req2 = 1; Req3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Req1 and Req3 (Priority Req1)", test_num);
            reset_dut();
            Req1 = 1; Req2 = 0; Req3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Req2 and Req3 (Priority Req2)", test_num);
            reset_dut();
            Req1 = 0; Req2 = 1; Req3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Requests active", test_num);
            reset_dut();
            Req1 = 1; Req2 = 1; Req3 = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Requests", test_num);
            reset_dut();
            Req1 = 0; Req2 = 0; Req3 = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check state during reset", test_num);
            reset = 1;
            Req1 = 1; Req2 = 1; Req3 = 1;
            #2;

            #1;


            check_outputs(0, 0, 0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_Grant1;
        input expected_Grant2;
        input expected_Grant3;
        begin
            if (expected_Grant1 === (expected_Grant1 ^ Grant1 ^ expected_Grant1) &&
                expected_Grant2 === (expected_Grant2 ^ Grant2 ^ expected_Grant2) &&
                expected_Grant3 === (expected_Grant3 ^ Grant3 ^ expected_Grant3)) begin
                $display("PASS");
                $display("  Outputs: Grant1=%b, Grant2=%b, Grant3=%b",
                         Grant1, Grant2, Grant3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Grant1=%b, Grant2=%b, Grant3=%b",
                         expected_Grant1, expected_Grant2, expected_Grant3);
                $display("  Got:      Grant1=%b, Grant2=%b, Grant3=%b",
                         Grant1, Grant2, Grant3);
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
        $dumpvars(0,Req1, Req2, Req3, clk, reset, Grant1, Grant2, Grant3);
    end

endmodule
