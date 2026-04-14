`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic write and read 8'hA5", test_num);

        we = 0; re = 0; data_in = 8'h00;
        #10;

        we = 1; data_in = 8'hA5;
        #10;

        we = 0; re = 1;
        #10;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic write and read 8'h5A", test_num);

        we = 0; re = 0; data_in = 8'h00;
        #10;

        we = 1; data_in = 8'h5A;
        #10;

        we = 0; re = 1;
        #10;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write and read 8'hFF", test_num);
        we = 0; re = 0; data_in = 8'h00;
        #10;
        we = 1; data_in = 8'hFF;
        #10;
        we = 0; re = 1;
        #10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Write and read 8'h00", test_num);
        we = 0; re = 0; data_in = 8'hFF;
        #10;
        we = 1; data_in = 8'h00;
        #10;
        we = 0; re = 1;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Data persistence check", test_num);
        we = 0; re = 0; data_in = 8'h00;
        #10;

        we = 1; data_in = 8'hC3;
        #10;

        we = 0; data_in = 8'h3C;
        #10;

        re = 1;
        #10;

        #1;


        check_outputs(8'hC3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Simultaneous Write and Read", test_num);
        we = 0; re = 0; data_in = 8'h00;
        #10;

        we = 1; re = 1; data_in = 8'h77;
        #10;
        #1;

        check_outputs(8'h77);
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
