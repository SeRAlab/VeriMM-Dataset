`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] i_addr;
    reg [15:0] i_data;
    reg i_enable_x;
    reg i_write_x;
    wire [15:0] o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_addr(i_addr),
        .i_data(i_data),
        .i_enable_x(i_enable_x),
        .i_write_x(i_write_x),
        .o_data(o_data)
    );
    task write_mem;

        input [5:0] addr;
        input [15:0] data;
        begin
            i_addr = addr;
            i_data = data;
            i_enable_x = 0;
            i_write_x = 1;
            #10;
            i_write_x = 0;
            #5;
        end
        endtask

    task setup_read;

        input [5:0] addr;
        begin
            i_addr = addr;
            i_enable_x = 0;
            i_write_x = 0;
            #10;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read at Address 0", test_num);

        i_enable_x = 0; i_write_x = 0; i_addr = 0; i_data = 0;
        #10;

        write_mem(6'd0, 16'hABCD);
        setup_read(6'd0);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High-Impedance Check (Enable Activated)", test_num);

        write_mem(6'd5, 16'h1234);
        i_addr = 6'd5;
        i_enable_x = 1;
        i_write_x = 0;
        #10;
        #1;

        check_outputs(16'hzzzz);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address Decoding (Boundary Check)", test_num);

        write_mem(6'd63, 16'hFFFF);
        write_mem(6'd32, 16'h55AA);

        setup_read(6'd63);
        #1;

        check_outputs(16'hFFFF);

        setup_read(6'd32);
        #1;

        check_outputs(16'h55AA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Overwrite and Stability", test_num);
        write_mem(6'd15, 16'hAAAA);
        write_mem(6'd15, 16'hBBBB);

        setup_read(6'd15);
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Output Suppression during Write", test_num);


        i_addr = 6'd20;
        i_data = 16'h7777;
        i_enable_x = 0;
        i_write_x = 1;
        #10;

        #1;


        check_outputs(16'hzzzz);


        setup_read(6'd20);
        #1;

        check_outputs(16'h7777);
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
        input [15:0] expected_o_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h",
                         o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h",
                         expected_o_data);
                $display("  Got:      o_data=%h",
                         o_data);
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
