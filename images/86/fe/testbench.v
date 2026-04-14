`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ADDR_in;
    reg [31:0] T0_data_in;
    reg [31:0] T1_data_in;
    reg we;
    wire [1:0] ADDR_T0_out;
    wire [1:0] ADDR_T1_out;
    wire [31:0] READ_data_out;
    wire T0_we;
    wire T1_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR_in(ADDR_in),
        .T0_data_in(T0_data_in),
        .T1_data_in(T1_data_in),
        .we(we),
        .ADDR_T0_out(ADDR_T0_out),
        .ADDR_T1_out(ADDR_T1_out),
        .READ_data_out(READ_data_out),
        .T0_we(T0_we),
        .T1_we(T1_we)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Read from T0 Range (Lower Boundary 0x7F00)", test_num);
            ADDR_in = 32'h00007F00;
            we = 1'b0;
            T0_data_in = 32'hAAAA_BBBB;
            T1_data_in = 32'hCCCC_DDDD;

            #1;


            check_outputs(2'b00, 2'b00, 32'hAAAA_BBBB, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write to T0 Range (Middle 0x7F04)", test_num);
            ADDR_in = 32'h00007F04;
            we = 1'b1;
            T0_data_in = 32'h1234_5678;
            T1_data_in = 32'h9ABC_DEF0;

            #1;


            check_outputs(2'b01, 2'b01, 32'h1234_5678, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write to T0 Range (Upper Boundary 0x7F0B)", test_num);
            ADDR_in = 32'h00007F0B;
            we = 1'b1;
            T0_data_in = 32'h5555_AAAA;
            T1_data_in = 32'h0;

            #1;


            check_outputs(2'b10, 2'b10, 32'h5555_AAAA, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Read from T1 Range (Lower Boundary 0x7F10)", test_num);
            ADDR_in = 32'h00007F10;
            we = 1'b0;
            T0_data_in = 32'h1111_1111;
            T1_data_in = 32'h2222_2222;

            #1;


            check_outputs(2'b00, 2'b00, 32'h2222_2222, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Write to T1 Range (Middle 0x7F14)", test_num);
            ADDR_in = 32'h00007F14;
            we = 1'b1;
            T0_data_in = 32'hDEAD_BEEF;
            T1_data_in = 32'hBABE_FACE;

            #1;


            check_outputs(2'b01, 2'b01, 32'hBABE_FACE, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Write to T1 Range (Upper Boundary 0x7F1B)", test_num);
            ADDR_in = 32'h00007F1B;
            we = 1'b1;
            T0_data_in = 32'h0;
            T1_data_in = 32'hFFFF_FFFF;

            #1;


            check_outputs(2'b10, 2'b10, 32'hFFFF_FFFF, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Access Address in Gap (0x7F0C)", test_num);
            ADDR_in = 32'h00007F0C;
            we = 1'b1;
            T0_data_in = 32'hAAAA_AAAA;
            T1_data_in = 32'hBBBB_BBBB;

            #1;


            check_outputs(2'b11, 2'b11, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Access Address Below T0 (0x7EFF)", test_num);
            ADDR_in = 32'h00007EFF;
            we = 1'b1;
            T0_data_in = 32'hAAAA_AAAA;
            T1_data_in = 32'hBBBB_BBBB;

            #1;


            check_outputs(2'b11, 2'b11, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Access Address Above T1 (0x7F1C)", test_num);
            ADDR_in = 32'h00007F1C;
            we = 1'b1;
            T0_data_in = 32'hAAAA_AAAA;
            T1_data_in = 32'hBBBB_BBBB;

            #1;


            check_outputs(2'b11, 2'b11, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Far Address Access (0x00000000)", test_num);
            ADDR_in = 32'h00000000;
            we = 1'b1;
            T0_data_in = 32'h1234_1234;
            T1_data_in = 32'h5678_5678;

            #1;


            check_outputs(2'b00, 2'b00, 32'h0, 1'b0, 1'b0);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_ADDR_T0_out;
        input [1:0] expected_ADDR_T1_out;
        input [31:0] expected_READ_data_out;
        input expected_T0_we;
        input expected_T1_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ADDR_T0_out === (expected_ADDR_T0_out ^ ADDR_T0_out ^ expected_ADDR_T0_out) &&
                expected_ADDR_T1_out === (expected_ADDR_T1_out ^ ADDR_T1_out ^ expected_ADDR_T1_out) &&
                expected_READ_data_out === (expected_READ_data_out ^ READ_data_out ^ expected_READ_data_out) &&
                expected_T0_we === (expected_T0_we ^ T0_we ^ expected_T0_we) &&
                expected_T1_we === (expected_T1_we ^ T1_we ^ expected_T1_we)) begin
                $display("PASS");
                $display("  Outputs: ADDR_T0_out=%h, ADDR_T1_out=%h, READ_data_out=%h, T0_we=%b, T1_we=%b",
                         ADDR_T0_out, ADDR_T1_out, READ_data_out, T0_we, T1_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADDR_T0_out=%h, ADDR_T1_out=%h, READ_data_out=%h, T0_we=%b, T1_we=%b",
                         expected_ADDR_T0_out, expected_ADDR_T1_out, expected_READ_data_out, expected_T0_we, expected_T1_we);
                $display("  Got:      ADDR_T0_out=%h, ADDR_T1_out=%h, READ_data_out=%h, T0_we=%b, T1_we=%b",
                         ADDR_T0_out, ADDR_T1_out, READ_data_out, T0_we, T1_we);
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
