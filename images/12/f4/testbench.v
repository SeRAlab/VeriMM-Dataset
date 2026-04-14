`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg re;
    reg we;
    wire [15:0] data_out;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .data_in(data_in),
        .re(re),
        .we(we),
        .data_out(data_out),
        .status(status)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Write and Read (0xAAAA)", test_num);

        we = 0; re = 0; data_in = 16'h0000;
        #10;

        we = 1; data_in = 16'hAAAA;
        #10;
        we = 0;
        #10;

        re = 1;
        #10;

        #1;


        check_outputs(16'hAAAA, 1'b1);
        re = 0;
        #10;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Write and Read (0x5555)", test_num);

        we = 0; re = 0; data_in = 16'h0000;
        #10;

        we = 1; data_in = 16'h5555;
        #10;
        we = 0;
        #10;

        re = 1;
        #10;

        #1;


        check_outputs(16'h5555, 1'b1);
        re = 0;
        #10;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write and Read All Ones (0xFFFF)", test_num);

        we = 0; re = 0; data_in = 16'h0000;
        #10;

        we = 1; data_in = 16'hFFFF;
        #10;
        we = 0;
        #10;

        re = 1;
        #10;

        #1;


        check_outputs(16'hFFFF, 1'b1);
        re = 0;
        #10;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data Persistence Check", test_num);

        we = 0; re = 0; data_in = 16'h0000;
        #10;

        we = 1; data_in = 16'h1234;
        #10;
        we = 0;
        #10;

        re = 1; #10; re = 0; #10;
        re = 1; #10;
        #1;

        check_outputs(16'h1234, 1'b1);
        re = 0;
        #10;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Status Signal during Write", test_num);

        we = 0; re = 0; data_in = 16'h0000;
        #10;

        we = 1; data_in = 16'hBEEF;
        #5;


        #1;



        check_outputs(data_out, 1'b1);
        we = 0;
        #10;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Idle State Check", test_num);

        we = 0; re = 0; data_in = 16'h0000;
        #10;

        #1;


        check_outputs(data_out, 1'b0);
        #10;
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write and Read All Zeros (0x0000)", test_num);

        we = 0; re = 0; data_in = 16'hFFFF;
        #10;

        we = 1; data_in = 16'h0000;
        #10;
        we = 0;
        #10;

        re = 1;
        #10;
        #1;

        check_outputs(16'h0000, 1'b1);
        re = 0;
        #10;
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
        testcase007();
        
        
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
        input [15:0] expected_data_out;
        input expected_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, status=%b",
                         data_out, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, status=%b",
                         expected_data_out, expected_status);
                $display("  Got:      data_out=%h, status=%b",
                         data_out, status);
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
