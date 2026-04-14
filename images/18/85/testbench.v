`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg re;
    reg we;
    wire [3:0] stored_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data(data),
        .re(re),
        .we(we),
        .stored_data(stored_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Write and Read", test_num);

            we = 0; re = 0; data = 4'b0000;
            #10;

            data = 4'hA; we = 1;
            #10;
            we = 0;
            #10;

            re = 1;
            #10;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Data Retention after WE goes low", test_num);

            we = 0; re = 0; data = 4'b0000;
            #10;

            data = 4'h5; we = 1;
            #10;
            we = 0;
            data = 4'hF;
            #10;

            re = 1;
            #10;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Overwrite previous data", test_num);

            we = 0; re = 0; data = 4'b0000;
            #10;

            data = 4'hC; we = 1;
            #10;

            data = 4'h3; we = 1;
            #10;
            we = 0;
            #10;

            re = 1;
            #10;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Read Enable isolation", test_num);

            we = 0; re = 0; data = 4'b0000;
            #10;

            data = 4'h7; we = 1;
            #10;
            we = 0;
            #10;

            re = 0;
            #10;


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Write Enable protection", test_num);

            we = 0; re = 0; data = 4'b0000;
            #10;

            data = 4'h9; we = 1;
            #10;
            we = 0;
            #10;

            data = 4'h2; we = 0;
            #10;

            re = 1;
            #10;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Simultaneous Read and Write", test_num);

            we = 0; re = 0; data = 4'b0000;
            #10;

            data = 4'hB; we = 1; re = 1;
            #10;

            #1;


            check_outputs(4'hB);
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
        input [3:0] expected_stored_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stored_data === (expected_stored_data ^ stored_data ^ expected_stored_data)) begin
                $display("PASS");
                $display("  Outputs: stored_data=%h",
                         stored_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_data=%h",
                         expected_stored_data);
                $display("  Got:      stored_data=%h",
                         stored_data);
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
