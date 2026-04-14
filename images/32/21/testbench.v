`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg we;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data(data),
        .we(we),
        .q(q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write and Read 4'h0", test_num);

            data = 4'h0;
            we = 1;
            #10;
            we = 0;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write and Read 4'h5 (pattern 0101)", test_num);
            data = 4'h5;
            we = 1;
            #10;
            we = 0;
            #10;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Data Hold when WE is low", test_num);

            data = 4'hA;
            we = 1;
            #10;
            we = 0;
            #10;

            data = 4'h3;
            #10;
            data = 4'hF;
            #10;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write and Read 4'hF (All bits High)", test_num);
            data = 4'hF;
            we = 1;
            #10;
            we = 0;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Write Toggle", test_num);

            data = 4'h8;
            we = 1;
            #5;

            data = 4'h2;
            #5;
            we = 0;
            #10;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwriting existing data", test_num);

            data = 4'h2;
            we = 0;
            #10;

            data = 4'h7;
            we = 1;
            #10;
            we = 0;
            #10;
            #1;

            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [3:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
