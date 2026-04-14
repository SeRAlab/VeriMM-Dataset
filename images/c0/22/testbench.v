`timescale 1ns/1ps

module dragonball_wbmaster_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] a;
    reg ack_i;
    reg clk;
    reg cs_n;
    reg [15:0] dat_i;
    reg err_i;
    reg lwe_n;
    reg oe_n;
    reg reset_n;
    reg uwe_n;
    wire [8:0] adr_o;
    wire berr;
    wire clk_o;
    wire cyc_o;
    wire [15:0] dat_o;
    wire dtack_n;
    wire rst_o;
    wire [1:0] sel_o;
    wire stb_o;
    wire we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dragonball_wbmaster dut (
        .a(a),
        .ack_i(ack_i),
        .clk(clk),
        .cs_n(cs_n),
        .dat_i(dat_i),
        .err_i(err_i),
        .lwe_n(lwe_n),
        .oe_n(oe_n),
        .reset_n(reset_n),
        .uwe_n(uwe_n),
        .adr_o(adr_o),
        .berr(berr),
        .clk_o(clk_o),
        .cyc_o(cyc_o),
        .dat_o(dat_o),
        .dtack_n(dtack_n),
        .rst_o(rst_o),
        .sel_o(sel_o),
        .stb_o(stb_o),
        .we_o(we_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            a = 0;
            ack_i = 0;
            cs_n = 1;
            dat_i = 0;
            err_i = 0;
            lwe_n = 1;
            uwe_n = 1;
            oe_n = 1;
            repeat(2) @(posedge clk);
            #1;
            reset_n = 1;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Idle State Check", test_num);

            #1;


            check_outputs(9'h000, 0, 1, 0, 16'h0000, 1, 0, 2'b00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Basic Word Read", test_num);
            @(posedge clk);
            #1;
            a = 9'h055;
            cs_n = 0;
            oe_n = 0;

            wait(cyc_o == 1);
            @(posedge clk);
            #1;
            dat_i = 16'hABCD;
            ack_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h055, 0, 1, 1, 16'h0000, 0, 0, 2'b11, 1, 0);


            cs_n = 1; oe_n = 1; ack_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Basic Word Write", test_num);
            @(posedge clk);
            #1;
            a = 9'h0AA;
            cs_n = 0;
            lwe_n = 0;
            uwe_n = 0;

            wait(cyc_o == 1);
            @(posedge clk);
            #1;
            ack_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h0AA, 0, 1, 1, dat_o, 0, 0, 2'b11, 1, 1);


            cs_n = 1; lwe_n = 1; uwe_n = 1; ack_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Bus Error Handling", test_num);
            @(posedge clk);
            #1;
            a = 9'h012;
            cs_n = 0;
            oe_n = 0;
            wait(cyc_o == 1);
            @(posedge clk);
            #1;
            err_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h012, 1, 1, 1, 16'h0000, dtack_n, 0, 2'b11, 1, 0);


            cs_n = 1; oe_n = 1; err_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Lower Byte Write (sel_o check)", test_num);
            @(posedge clk);
            #1;
            a = 9'h0F0;
            cs_n = 0;
            lwe_n = 0;
            uwe_n = 1;
            wait(cyc_o == 1);
            @(posedge clk);
            #1;
            ack_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h0F0, 0, 1, 1, dat_o, 0, 0, 2'b01, 1, 1);


            cs_n = 1; lwe_n = 1; ack_i = 0;
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Upper Byte Write (sel_o check)", test_num);
            @(posedge clk);
            #1;
            a = 9'h0CC;
            cs_n = 0;
            lwe_n = 1;
            uwe_n = 0;
            wait(cyc_o == 1);
            @(posedge clk);
            #1;
            ack_i = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(9'h0CC, 0, 1, 1, dat_o, 0, 0, 2'b10, 1, 1);


            cs_n = 1; uwe_n = 1; ack_i = 0;
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dragonball_wbmaster Testbench");
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
        input [8:0] expected_adr_o;
        input expected_berr;
        input expected_clk_o;
        input expected_cyc_o;
        input [15:0] expected_dat_o;
        input expected_dtack_n;
        input expected_rst_o;
        input [1:0] expected_sel_o;
        input expected_stb_o;
        input expected_we_o;
        begin
            if (expected_adr_o === (expected_adr_o ^ adr_o ^ expected_adr_o) &&
                expected_berr === (expected_berr ^ berr ^ expected_berr) &&
                expected_clk_o === (expected_clk_o ^ clk_o ^ expected_clk_o) &&
                expected_cyc_o === (expected_cyc_o ^ cyc_o ^ expected_cyc_o) &&
                expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_dtack_n === (expected_dtack_n ^ dtack_n ^ expected_dtack_n) &&
                expected_rst_o === (expected_rst_o ^ rst_o ^ expected_rst_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o) &&
                expected_stb_o === (expected_stb_o ^ stb_o ^ expected_stb_o) &&
                expected_we_o === (expected_we_o ^ we_o ^ expected_we_o)) begin
                $display("PASS");
                $display("  Outputs: adr_o=%h, berr=%b, clk_o=%b, cyc_o=%b, dat_o=%h, dtack_n=%b, rst_o=%b, sel_o=%h, stb_o=%b, we_o=%b",
                         adr_o, berr, clk_o, cyc_o, dat_o, dtack_n, rst_o, sel_o, stb_o, we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adr_o=%h, berr=%b, clk_o=%b, cyc_o=%b, dat_o=%h, dtack_n=%b, rst_o=%b, sel_o=%h, stb_o=%b, we_o=%b",
                         expected_adr_o, expected_berr, expected_clk_o, expected_cyc_o, expected_dat_o, expected_dtack_n, expected_rst_o, expected_sel_o, expected_stb_o, expected_we_o);
                $display("  Got:      adr_o=%h, berr=%b, clk_o=%b, cyc_o=%b, dat_o=%h, dtack_n=%b, rst_o=%b, sel_o=%h, stb_o=%b, we_o=%b",
                         adr_o, berr, clk_o, cyc_o, dat_o, dtack_n, rst_o, sel_o, stb_o, we_o);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, ack_i, clk, cs_n, dat_i, err_i, lwe_n, oe_n, reset_n, uwe_n, adr_o, berr, clk_o, cyc_o, dat_o, dtack_n, rst_o, sel_o, stb_o, we_o);
    end

endmodule
