`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] addr;
    reg [2:0] ba;
    reg cas_n;
    reg ck_n;
    reg ck_p;
    reg cke;
    reg cs_n;
    reg [3:0] dm;
    reg [31:0] dq;
    reg [3:0] dqs_n;
    reg [3:0] dqs_p;
    reg odt;
    reg ras_n;
    reg reset_n;
    reg we_n;
    wire [7:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .ba(ba),
        .cas_n(cas_n),
        .ck_n(ck_n),
        .ck_p(ck_p),
        .cke(cke),
        .cs_n(cs_n),
        .dm(dm),
        .dq(dq),
        .dqs_n(dqs_n),
        .dqs_p(dqs_p),
        .odt(odt),
        .ras_n(ras_n),
        .reset_n(reset_n),
        .we_n(we_n),
        .led(led)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write 0xAA to Bank 0 and update LED", test_num);
            reset_dut();


            cs_n = 0; we_n = 0; ba = 3'b000; dq = 32'h0000_00AA; dm = 4'b0000;
            #10;


            we_n = 1;
            #10;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write 0x55 to Bank 5 and update LED", test_num);
            reset_dut();


            cs_n = 0; we_n = 0; ba = 3'b101; dq = 32'h0000_0055; dm = 4'b0000;
            #10;


            we_n = 1;
            #10;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Masking test (Should not update)", test_num);
            reset_dut();


            cs_n = 0; we_n = 0; ba = 3'b000; dq = 32'h0000_00FF; dm = 4'b0000;
            #10;


            dq = 32'h0000_0000; dm = 4'b0001;
            #10;


            we_n = 1;
            #10;


            #1;



            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Chip Select de-asserted test", test_num);
            reset_dut();


            cs_n = 1; we_n = 0; ba = 3'b000; dq = 32'h0000_00CC; dm = 4'b0000;
            #10;


            we_n = 1;
            #10;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Bank Isolation test", test_num);
            reset_dut();


            cs_n = 0; we_n = 0; ba = 3'b001; dq = 32'h0000_0011; #10;

            cs_n = 0; we_n = 0; ba = 3'b010; dq = 32'h0000_0022; #10;


            cs_n = 0; we_n = 1; ba = 3'b001; #10;


            #1;



            check_outputs(8'h11);
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
        input [7:0] expected_led;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
