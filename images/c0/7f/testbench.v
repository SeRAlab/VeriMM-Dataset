`timescale 1ns/1ps

module aluout_tb;

    // Testbench signals (combinational circuit)
    reg adder_c;
    reg adder_hc;
    reg [15:0] adder_out;
    reg hi_byte;
    reg logic_c;
    reg logic_hc;
    reg [15:0] logic_out;
    reg [15:0] mult_out;
    reg shft_c;
    reg [7:0] shft_out;
    reg [1:0] unit_sel;
    reg word_op;
    wire cry_nxt;
    wire [15:0] data_bus;
    wire hcar_nxt;
    wire one_nxt;
    wire par_nxt;
    wire sign_nxt;
    wire zero_nxt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aluout dut (
        .adder_c(adder_c),
        .adder_hc(adder_hc),
        .adder_out(adder_out),
        .hi_byte(hi_byte),
        .logic_c(logic_c),
        .logic_hc(logic_hc),
        .logic_out(logic_out),
        .mult_out(mult_out),
        .shft_c(shft_c),
        .shft_out(shft_out),
        .unit_sel(unit_sel),
        .word_op(word_op),
        .cry_nxt(cry_nxt),
        .data_bus(data_bus),
        .hcar_nxt(hcar_nxt),
        .one_nxt(one_nxt),
        .par_nxt(par_nxt),
        .sign_nxt(sign_nxt),
        .zero_nxt(zero_nxt)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aluout Testbench");
        $display("========================================");


        
        
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
        input expected_cry_nxt;
        input [15:0] expected_data_bus;
        input expected_hcar_nxt;
        input expected_one_nxt;
        input expected_par_nxt;
        input expected_sign_nxt;
        input expected_zero_nxt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cry_nxt === (expected_cry_nxt ^ cry_nxt ^ expected_cry_nxt) &&
                expected_data_bus === (expected_data_bus ^ data_bus ^ expected_data_bus) &&
                expected_hcar_nxt === (expected_hcar_nxt ^ hcar_nxt ^ expected_hcar_nxt) &&
                expected_one_nxt === (expected_one_nxt ^ one_nxt ^ expected_one_nxt) &&
                expected_par_nxt === (expected_par_nxt ^ par_nxt ^ expected_par_nxt) &&
                expected_sign_nxt === (expected_sign_nxt ^ sign_nxt ^ expected_sign_nxt) &&
                expected_zero_nxt === (expected_zero_nxt ^ zero_nxt ^ expected_zero_nxt)) begin
                $display("PASS");
                $display("  Outputs: cry_nxt=%b, data_bus=%h, hcar_nxt=%b, one_nxt=%b, par_nxt=%b, sign_nxt=%b, zero_nxt=%b",
                         cry_nxt, data_bus, hcar_nxt, one_nxt, par_nxt, sign_nxt, zero_nxt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cry_nxt=%b, data_bus=%h, hcar_nxt=%b, one_nxt=%b, par_nxt=%b, sign_nxt=%b, zero_nxt=%b",
                         expected_cry_nxt, expected_data_bus, expected_hcar_nxt, expected_one_nxt, expected_par_nxt, expected_sign_nxt, expected_zero_nxt);
                $display("  Got:      cry_nxt=%b, data_bus=%h, hcar_nxt=%b, one_nxt=%b, par_nxt=%b, sign_nxt=%b, zero_nxt=%b",
                         cry_nxt, data_bus, hcar_nxt, one_nxt, par_nxt, sign_nxt, zero_nxt);
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
