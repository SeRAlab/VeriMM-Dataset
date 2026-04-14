`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] in;
    reg [3:0] key_hi;
    reg [3:0] key_lo;
    reg [7:0] sel;
    wire [7:0] encrypted_msg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .key_hi(key_hi),
        .key_lo(key_lo),
        .sel(sel),
        .encrypted_msg(encrypted_msg)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: All Zeros", test_num);
        in = 256'h0;
        sel = 8'h00;
        key_hi = 4'h0;
        key_lo = 4'h0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Nibble Swap Check", test_num);
        in = 256'h0;
        in[7:0] = 8'hF0;
        sel = 8'h00;
        key_hi = 4'h0;
        key_lo = 4'h0;

        #1;


        check_outputs(8'h0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Key XOR Check", test_num);
        in = 256'h0;
        in[7:0] = 8'hF0;
        sel = 8'h00;
        key_hi = 4'hA;
        key_lo = 4'h5;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mux Index Selection", test_num);
        in = 256'h0;
        in[135:128] = 8'h12;
        sel = 8'd128;
        key_hi = 4'h0;
        key_lo = 4'h0;

        #1;


        check_outputs(8'h21);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Selection Wrap-around Check", test_num);
        in = 256'h0;




        in[255] = 1'b1; in[0] = 1'b1; in[1] = 1'b1; in[2] = 1'b1;
        in[3] = 1'b0;   in[4] = 1'b0; in[5] = 1'b0; in[6] = 1'b0;
        sel = 8'd255;
        key_hi = 4'h0;
        key_lo = 4'h0;

        #1;


        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Pattern and Full Key", test_num);
        in = {32{8'hAA}};
        sel = 8'd64;
        key_hi = 4'hF;
        key_lo = 4'hF;

        #1;


        check_outputs(8'h55);
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
        input [7:0] expected_encrypted_msg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encrypted_msg === (expected_encrypted_msg ^ encrypted_msg ^ expected_encrypted_msg)) begin
                $display("PASS");
                $display("  Outputs: encrypted_msg=%h",
                         encrypted_msg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_msg=%h",
                         expected_encrypted_msg);
                $display("  Got:      encrypted_msg=%h",
                         encrypted_msg);
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
