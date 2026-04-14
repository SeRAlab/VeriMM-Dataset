`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg request1;
    reg request2;
    reg reset;
    wire grant1;
    wire grant2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request1(request1),
        .request2(request2),
        .reset(reset),
        .grant1(grant1),
        .grant2(grant2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request1 = 0;
            request2 = 0;
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
            $display("\nTestcase %0d: Check Reset Condition", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Request 1 Only", test_num);
            reset_dut();
            request1 = 1;
            request2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Request 2 Only", test_num);
            reset_dut();
            request1 = 0;
            request2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Priority Check (Both active)", test_num);
            reset_dut();
            request1 = 1;
            request2 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition Req1 to Req2", test_num);
            reset_dut();
            request1 = 1;
            request2 = 1;
            @(posedge clk);
            #1;
            request1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All requests inactive", test_num);
            reset_dut();
            request1 = 1;
            request2 = 1;
            @(posedge clk);
            #1;
            request1 = 0;
            request2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during active requests", test_num);
            reset_dut();
            request1 = 1;
            request2 = 0;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pre-empting Req2 with Req1", test_num);
            reset_dut();
            request2 = 1;
            @(posedge clk);
            #1;
            request1 = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_grant1;
        input expected_grant2;
        begin
            if (expected_grant1 === (expected_grant1 ^ grant1 ^ expected_grant1) &&
                expected_grant2 === (expected_grant2 ^ grant2 ^ expected_grant2)) begin
                $display("PASS");
                $display("  Outputs: grant1=%b, grant2=%b",
                         grant1, grant2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant1=%b, grant2=%b",
                         expected_grant1, expected_grant2);
                $display("  Got:      grant1=%b, grant2=%b",
                         grant1, grant2);
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
        $dumpvars(0,clk, request1, request2, reset, grant1, grant2);
    end

endmodule
