`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg last_in;
    reg ready_out;
    reg reset_in;
    reg [7:0] set_addr_in;
    reg set_strb_in;
    reg valid_in;
    wire axi_fifo_m_axis_tlast_net;
    wire [31:0] concat_y_net;
    wire ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net;
    wire logical_y_net;
    wire ready_out_net;
    wire [7:0] set_addr_in_net;
    wire set_stb_in_net;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .last_in(last_in),
        .ready_out(ready_out),
        .reset_in(reset_in),
        .set_addr_in(set_addr_in),
        .set_strb_in(set_strb_in),
        .valid_in(valid_in),
        .axi_fifo_m_axis_tlast_net(axi_fifo_m_axis_tlast_net),
        .concat_y_net(concat_y_net),
        .ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net(ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net),
        .logical_y_net(logical_y_net),
        .ready_out_net(ready_out_net),
        .set_addr_in_net(set_addr_in_net),
        .set_stb_in_net(set_stb_in_net)
    );
    task testcase001;

        begin
            test_num = 1;

            reset_in = 1'b1;
            valid_in = 1'b0;
            data_in = 32'h0;
            last_in = 1'b0;
            set_strb_in = 1'b0;
            set_addr_in = 8'h00;
            ready_out = 1'b0;
            #10;



            #1;




            check_outputs(1'b0, 32'h00000000, 1'b0, 1'b1, 1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            reset_in = 1'b1;
            #5 reset_in = 1'b0;


            valid_in = 1'b1;
            data_in = 32'hDEADBEEF;
            last_in = 1'b0;
            set_strb_in = 1'b0;
            set_addr_in = 8'h00;
            ready_out = 1'b1;
            #10;



            #1;




            check_outputs(1'b0, 32'hDEADBEEF, 1'b1, 1'b0, 1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            reset_in = 1'b1;
            #5 reset_in = 1'b0;


            valid_in = 1'b0;
            data_in = 32'h0;
            last_in = 1'b0;
            set_strb_in = 1'b1;
            set_addr_in = 8'hA5;
            ready_out = 1'b0;
            #10;



            #1;




            check_outputs(1'b0, 32'h00000000, 1'b0, 1'b0, 1'b0, 8'hA5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            reset_in = 1'b1;
            #5 reset_in = 1'b0;


            valid_in = 1'b1;
            data_in = 32'h12345678;
            last_in = 1'b1;
            set_strb_in = 1'b0;
            set_addr_in = 8'h00;
            ready_out = 1'b1;
            #10;



            #1;




            check_outputs(1'b1, 32'h12345678, 1'b1, 1'b0, 1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            reset_in = 1'b1;
            #5 reset_in = 1'b0;


            valid_in = 1'b1;
            data_in = 32'hCAFEBABE;
            last_in = 1'b0;
            set_strb_in = 1'b0;
            set_addr_in = 8'hFF;
            ready_out = 1'b0;
            #10;



            #1;




            check_outputs(1'b0, 32'hCAFEBABE, 1'b1, 1'b0, 1'b0, 8'hFF, 1'b0);
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
        input expected_axi_fifo_m_axis_tlast_net;
        input [31:0] expected_concat_y_net;
        input expected_ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net;
        input expected_logical_y_net;
        input expected_ready_out_net;
        input [7:0] expected_set_addr_in_net;
        input expected_set_stb_in_net;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_axi_fifo_m_axis_tlast_net === (expected_axi_fifo_m_axis_tlast_net ^ axi_fifo_m_axis_tlast_net ^ expected_axi_fifo_m_axis_tlast_net) &&
                expected_concat_y_net === (expected_concat_y_net ^ concat_y_net ^ expected_concat_y_net) &&
                expected_ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net === (expected_ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net ^ ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net ^ expected_ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net) &&
                expected_logical_y_net === (expected_logical_y_net ^ logical_y_net ^ expected_logical_y_net) &&
                expected_ready_out_net === (expected_ready_out_net ^ ready_out_net ^ expected_ready_out_net) &&
                expected_set_addr_in_net === (expected_set_addr_in_net ^ set_addr_in_net ^ expected_set_addr_in_net) &&
                expected_set_stb_in_net === (expected_set_stb_in_net ^ set_stb_in_net ^ expected_set_stb_in_net)) begin
                $display("PASS");
                $display("  Outputs: axi_fifo_m_axis_tlast_net=%b, concat_y_net=%h, ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net=%b, logical_y_net=%b, ready_out_net=%b, set_addr_in_net=%h, set_stb_in_net=%b",
                         axi_fifo_m_axis_tlast_net, concat_y_net, ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net, logical_y_net, ready_out_net, set_addr_in_net, set_stb_in_net);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: axi_fifo_m_axis_tlast_net=%b, concat_y_net=%h, ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net=%b, logical_y_net=%b, ready_out_net=%b, set_addr_in_net=%h, set_stb_in_net=%b",
                         expected_axi_fifo_m_axis_tlast_net, expected_concat_y_net, expected_ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net, expected_logical_y_net, expected_ready_out_net, expected_set_addr_in_net, expected_set_stb_in_net);
                $display("  Got:      axi_fifo_m_axis_tlast_net=%b, concat_y_net=%h, ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net=%b, logical_y_net=%b, ready_out_net=%b, set_addr_in_net=%h, set_stb_in_net=%b",
                         axi_fifo_m_axis_tlast_net, concat_y_net, ifft_fast_fourier_transform_8_1_m_axis_data_tvalid_net, logical_y_net, ready_out_net, set_addr_in_net, set_stb_in_net);
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
