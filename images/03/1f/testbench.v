`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    reg WE;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .WE(WE),
        .Q(Q)
    );
    task dram_write;

        input [3:0] val;
        begin
            D = val;
            WE = 1;
            #10;
            WE = 0;
            #10;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write 4'h5 and verify output", test_num);

            WE = 0; D = 4'h0; #5;

            dram_write(4'h5);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write 4'hA and verify output", test_num);
            dram_write(4'hA);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Ensure Q remains stable when D changes while WE is Low", test_num);

            dram_write(4'hC);

            D = 4'h0;
            #5;
            D = 4'hF;
            #5;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write All-Ones (4'hF) and verify", test_num);
            dram_write(4'hF);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write All-Zeros (4'h0) and verify", test_num);
            dram_write(4'h0);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Test transparent behavior (WE high, then low)", test_num);
            WE = 1;
            D = 4'h3;
            #5;
            D = 4'h9;
            #5;
            WE = 0;
            #5;
            D = 4'h2;
            #5;
            #1;

            check_outputs(4'h9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
