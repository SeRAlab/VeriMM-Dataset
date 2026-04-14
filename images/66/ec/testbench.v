`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] d_i;
    reg rp_inc_i;
    reg sys_clk_i;
    reg sys_reset_i;
    reg we_i;
    reg wp_inc_i;
    wire data_available_o;
    wire full_o;
    wire [7:0] q_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_i(d_i),
        .rp_inc_i(rp_inc_i),
        .sys_clk_i(sys_clk_i),
        .sys_reset_i(sys_reset_i),
        .we_i(we_i),
        .wp_inc_i(wp_inc_i),
        .data_available_o(data_available_o),
        .full_o(full_o),
        .q_o(q_o)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk_i = 0;
        forever #5 sys_clk_i = ~sys_clk_i;
    end

        task reset_dut;

        begin
            sys_reset_i = 1;
            d_i = 8'h0;
            we_i = 0;
            wp_inc_i = 0;
            rp_inc_i = 0;
            #15;
            sys_reset_i = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 8'bzzzzzzzz);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write Operation", test_num);
            reset_dut();
            @(negedge sys_clk_i);
            d_i = 8'hA5;
            we_i = 1;
            wp_inc_i = 1;
            @(negedge sys_clk_i);
            we_i = 0;
            wp_inc_i = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO to 16 entries", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge sys_clk_i);
                d_i = i + 8'h10;
                we_i = 1;
                wp_inc_i = 1;
            end
            @(negedge sys_clk_i);
            we_i = 0;
            wp_inc_i = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 8'h10);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Read all entries until empty", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(negedge sys_clk_i);
                d_i = i + 1;
                we_i = 1;
                wp_inc_i = 1;
            end
            @(negedge sys_clk_i);
            we_i = 0; wp_inc_i = 0;


            for (i = 0; i < 16; i = i + 1) begin
                @(negedge sys_clk_i);
                rp_inc_i = 1;
            end
            @(negedge sys_clk_i);
            rp_inc_i = 0;
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 8'bzzzzzzzz);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Overflow Protection Check", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(negedge sys_clk_i);
                d_i = 8'hFF;
                we_i = 1;
                wp_inc_i = 1;
            end

            @(negedge sys_clk_i);
            d_i = 8'hEE;
            we_i = 1;
            wp_inc_i = 1;
            @(negedge sys_clk_i);
            we_i = 0; wp_inc_i = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Pointer Wrap-around Check", test_num);
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                @(negedge sys_clk_i);
                d_i = i;
                we_i = 1;
                wp_inc_i = 1;
            end

            for (i = 0; i < 10; i = i + 1) begin
                @(negedge sys_clk_i);
                rp_inc_i = 1;
            end
            @(negedge sys_clk_i);
            rp_inc_i = 0;

            for (i = 0; i < 10; i = i + 1) begin
                @(negedge sys_clk_i);
                d_i = 8'hCC;
                we_i = 1;
                wp_inc_i = 1;
            end
            @(negedge sys_clk_i);
            we_i = 0; wp_inc_i = 0;
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 8'hCC);
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
        input expected_data_available_o;
        input expected_full_o;
        input [7:0] expected_q_o;
        begin
            if (expected_data_available_o === (expected_data_available_o ^ data_available_o ^ expected_data_available_o) &&
                expected_full_o === (expected_full_o ^ full_o ^ expected_full_o) &&
                expected_q_o === (expected_q_o ^ q_o ^ expected_q_o)) begin
                $display("PASS");
                $display("  Outputs: data_available_o=%b, full_o=%b, q_o=%h",
                         data_available_o, full_o, q_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_available_o=%b, full_o=%b, q_o=%h",
                         expected_data_available_o, expected_full_o, expected_q_o);
                $display("  Got:      data_available_o=%b, full_o=%b, q_o=%h",
                         data_available_o, full_o, q_o);
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
        $dumpvars(0,d_i, rp_inc_i, sys_clk_i, sys_reset_i, we_i, wp_inc_i, data_available_o, full_o, q_o);
    end

endmodule
