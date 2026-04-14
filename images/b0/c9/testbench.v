`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] address;
    reg [7:0] data_in;
    reg reset;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .data_in(data_in),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read (Data: 0xAA, Addr: 0x0)", test_num);

        reset = 1; write_en = 0; data_in = 8'h00; address = 4'h0; #10;
        reset = 0; #10;


        address = 4'h0;
        data_in = 8'hAA;
        write_en = 1;
        #10;
        write_en = 0;
        #10;


        #1;



        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read at Max Address (Data: 0x55, Addr: 0xF)", test_num);

        reset = 1; write_en = 0; data_in = 8'h00; address = 4'h0; #10;
        reset = 0; #10;


        address = 4'hF;
        data_in = 8'h55;
        write_en = 1;
        #10;
        write_en = 0;
        #10;


        #1;



        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read All Zeros (Data: 0x00, Addr: 0x7)", test_num);

        reset = 1; write_en = 0; data_in = 8'h00; address = 4'h0; #10;
        reset = 0; #10;


        address = 4'h7;
        data_in = 8'h00;
        write_en = 1;
        #10;
        write_en = 0;
        #10;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write and Read All Ones (Data: 0xFF, Addr: 0xC)", test_num);

        reset = 1; write_en = 0; data_in = 8'h00; address = 4'h0; #10;
        reset = 0; #10;


        address = 4'hC;
        data_in = 8'hFF;
        write_en = 1;
        #10;
        write_en = 0;
        #10;


        #1;



        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Reset Clears Memory", test_num);

        reset = 1; write_en = 0; data_in = 8'h00; address = 4'h0; #10;
        reset = 0; #10;


        address = 4'h3;
        data_in = 8'hEE;
        write_en = 1;
        #10;
        write_en = 0;
        #10;


        reset = 1;
        #10;
        reset = 0;
        #10;


        address = 4'h3;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits Pattern (Data: 0x33, Addr: 0x9)", test_num);

        reset = 1; write_en = 0; data_in = 8'h00; address = 4'h0; #10;
        reset = 0; #10;


        address = 4'h9;
        data_in = 8'h33;
        write_en = 1;
        #10;
        write_en = 0;
        #10;


        #1;



        check_outputs(8'h33);
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
