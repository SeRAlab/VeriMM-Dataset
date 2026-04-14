`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ack_i;
    reg [31:0] dat_i;
    reg [29:0] m0_addr_i;
    reg m0_read_request_i;
    reg [3:0] m0_sel_i;
    reg [29:0] m1_addr_i;
    reg m1_read_request_i;
    reg [3:0] m1_sel_i;
    reg [29:0] m2_addr_i;
    reg m2_read_request_i;
    reg [3:0] m2_sel_i;
    wire [29:0] addr_o;
    wire m0_ack_o;
    wire [31:0] m0_dat_o;
    wire m1_ack_o;
    wire [31:0] m1_dat_o;
    wire m2_ack_o;
    wire [31:0] m2_dat_o;
    wire master_busy_o;
    wire read_request_o;
    wire [3:0] sel_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack_i(ack_i),
        .dat_i(dat_i),
        .m0_addr_i(m0_addr_i),
        .m0_read_request_i(m0_read_request_i),
        .m0_sel_i(m0_sel_i),
        .m1_addr_i(m1_addr_i),
        .m1_read_request_i(m1_read_request_i),
        .m1_sel_i(m1_sel_i),
        .m2_addr_i(m2_addr_i),
        .m2_read_request_i(m2_read_request_i),
        .m2_sel_i(m2_sel_i),
        .addr_o(addr_o),
        .m0_ack_o(m0_ack_o),
        .m0_dat_o(m0_dat_o),
        .m1_ack_o(m1_ack_o),
        .m1_dat_o(m1_dat_o),
        .m2_ack_o(m2_ack_o),
        .m2_dat_o(m2_dat_o),
        .master_busy_o(master_busy_o),
        .read_request_o(read_request_o),
        .sel_o(sel_o)
    );
    task reset_inputs;

        begin
            ack_i = 0;
            dat_i = 0;
            m0_addr_i = 0;
            m0_read_request_i = 0;
            m0_sel_i = 0;
            m1_addr_i = 0;
            m1_read_request_i = 0;
            m1_sel_i = 0;
            m2_addr_i = 0;
            m2_read_request_i = 0;
            m2_sel_i = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: No requests", test_num);
            reset_inputs();

            #1;


            check_outputs(30'h0, 1'b0, 32'h0, 1'b0, 32'h0, 1'b0, 32'h0, 1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Master 0 request", test_num);
            reset_inputs();
            m0_read_request_i = 1;
            m0_addr_i = 30'h1AAAAAAA;
            m0_sel_i = 4'hF;
            ack_i = 1;
            dat_i = 32'hDEADBEEF;


            #1;



            check_outputs(30'h1AAAAAAA, 1'b1, 32'hDEADBEEF, 1'b0, 32'h0, 1'b0, 32'h0, 1'b1, 1'b1, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Master 1 request", test_num);
            reset_inputs();
            m1_read_request_i = 1;
            m1_addr_i = 30'h2BBBBBBB;
            m1_sel_i = 4'h3;
            ack_i = 1;
            dat_i = 32'hCAFEBABE;


            #1;



            check_outputs(30'h2BBBBBBB, 1'b0, 32'h0, 1'b1, 32'hCAFEBABE, 1'b0, 32'h0, 1'b1, 1'b1, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Master 2 request", test_num);
            reset_inputs();
            m2_read_request_i = 1;
            m2_addr_i = 30'h3CCCCCCC;
            m2_sel_i = 4'h1;
            ack_i = 1;
            dat_i = 32'hBAADF00D;


            #1;



            check_outputs(30'h3CCCCCCC, 1'b0, 32'h0, 1'b0, 32'h0, 1'b1, 32'hBAADF00D, 1'b1, 1'b1, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Priority - M0 vs M1", test_num);
            reset_inputs();
            m0_read_request_i = 1;
            m0_addr_i = 30'h1AAAAAAA;
            m0_sel_i = 4'hF;

            m1_read_request_i = 1;
            m1_addr_i = 30'h2BBBBBBB;
            m1_sel_i = 4'h3;

            ack_i = 1;
            dat_i = 32'h11112222;


            #1;



            check_outputs(30'h1AAAAAAA, 1'b1, 32'h11112222, 1'b0, 32'h0, 1'b0, 32'h0, 1'b1, 1'b1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Priority - M1 vs M2", test_num);
            reset_inputs();
            m1_read_request_i = 1;
            m1_addr_i = 30'h2BBBBBBB;
            m1_sel_i = 4'h3;

            m2_read_request_i = 1;
            m2_addr_i = 30'h3CCCCCCC;
            m2_sel_i = 4'h1;

            ack_i = 1;
            dat_i = 32'h33334444;


            #1;



            check_outputs(30'h2BBBBBBB, 1'b0, 32'h0, 1'b1, 32'h33334444, 1'b0, 32'h0, 1'b1, 1'b1, 4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Priority - All masters requesting", test_num);
            reset_inputs();
            m0_read_request_i = 1; m0_addr_i = 30'h0A; m0_sel_i = 4'h1;
            m1_read_request_i = 1; m1_addr_i = 30'h0B; m1_sel_i = 4'h2;
            m2_read_request_i = 1; m2_addr_i = 30'h0C; m2_sel_i = 4'h4;

            ack_i = 1;
            dat_i = 32'h55556666;


            #1;



            check_outputs(30'h0A, 1'b1, 32'h55556666, 1'b0, 32'h0, 1'b0, 32'h0, 1'b1, 1'b1, 4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Request active, no memory ACK", test_num);
            reset_inputs();
            m2_read_request_i = 1;
            m2_addr_i = 30'h3CCCCCCC;
            m2_sel_i = 4'h1;

            ack_i = 0;
            dat_i = 32'hXXXXXXXX;


            #1;



            check_outputs(30'h3CCCCCCC, 1'b0, 32'h0, 1'b0, 32'h0, 1'b0, 32'hXXXXXXXX, 1'b1, 1'b1, 4'h1);
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
        input [29:0] expected_addr_o;
        input expected_m0_ack_o;
        input [31:0] expected_m0_dat_o;
        input expected_m1_ack_o;
        input [31:0] expected_m1_dat_o;
        input expected_m2_ack_o;
        input [31:0] expected_m2_dat_o;
        input expected_master_busy_o;
        input expected_read_request_o;
        input [3:0] expected_sel_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr_o === (expected_addr_o ^ addr_o ^ expected_addr_o) &&
                expected_m0_ack_o === (expected_m0_ack_o ^ m0_ack_o ^ expected_m0_ack_o) &&
                expected_m0_dat_o === (expected_m0_dat_o ^ m0_dat_o ^ expected_m0_dat_o) &&
                expected_m1_ack_o === (expected_m1_ack_o ^ m1_ack_o ^ expected_m1_ack_o) &&
                expected_m1_dat_o === (expected_m1_dat_o ^ m1_dat_o ^ expected_m1_dat_o) &&
                expected_m2_ack_o === (expected_m2_ack_o ^ m2_ack_o ^ expected_m2_ack_o) &&
                expected_m2_dat_o === (expected_m2_dat_o ^ m2_dat_o ^ expected_m2_dat_o) &&
                expected_master_busy_o === (expected_master_busy_o ^ master_busy_o ^ expected_master_busy_o) &&
                expected_read_request_o === (expected_read_request_o ^ read_request_o ^ expected_read_request_o) &&
                expected_sel_o === (expected_sel_o ^ sel_o ^ expected_sel_o)) begin
                $display("PASS");
                $display("  Outputs: addr_o=%h, m0_ack_o=%b, m0_dat_o=%h, m1_ack_o=%b, m1_dat_o=%h, m2_ack_o=%b, m2_dat_o=%h, master_busy_o=%b, read_request_o=%b, sel_o=%h",
                         addr_o, m0_ack_o, m0_dat_o, m1_ack_o, m1_dat_o, m2_ack_o, m2_dat_o, master_busy_o, read_request_o, sel_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_o=%h, m0_ack_o=%b, m0_dat_o=%h, m1_ack_o=%b, m1_dat_o=%h, m2_ack_o=%b, m2_dat_o=%h, master_busy_o=%b, read_request_o=%b, sel_o=%h",
                         expected_addr_o, expected_m0_ack_o, expected_m0_dat_o, expected_m1_ack_o, expected_m1_dat_o, expected_m2_ack_o, expected_m2_dat_o, expected_master_busy_o, expected_read_request_o, expected_sel_o);
                $display("  Got:      addr_o=%h, m0_ack_o=%b, m0_dat_o=%h, m1_ack_o=%b, m1_dat_o=%h, m2_ack_o=%b, m2_dat_o=%h, master_busy_o=%b, read_request_o=%b, sel_o=%h",
                         addr_o, m0_ack_o, m0_dat_o, m1_ack_o, m1_dat_o, m2_ack_o, m2_dat_o, master_busy_o, read_request_o, sel_o);
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
