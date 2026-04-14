`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_dmem_ram_i;
    reg clk;
    reg [31:0] wr_data_dmem_ram_i;
    reg wr_en_dmem_ram_i;
    reg [3:0] wr_strb_dmem_ram_i;
    wire [31:0] read_data_dmem_ram_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_dmem_ram_i(addr_dmem_ram_i),
        .clk(clk),
        .wr_data_dmem_ram_i(wr_data_dmem_ram_i),
        .wr_en_dmem_ram_i(wr_en_dmem_ram_i),
        .wr_strb_dmem_ram_i(wr_strb_dmem_ram_i),
        .read_data_dmem_ram_o(read_data_dmem_ram_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_dmem_ram_i = 32'b0;
            wr_data_dmem_ram_i = 32'b0;
            wr_en_dmem_ram_i = 1'b0;
            wr_strb_dmem_ram_i = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Full Word Write and Read", test_num);
            reset_dut();


            addr_dmem_ram_i = 32'h0;
            wr_data_dmem_ram_i = 32'h12345678;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b1111;
            @(posedge clk);
            #1;


            wr_en_dmem_ram_i = 1'b0;
            addr_dmem_ram_i = 32'h0;
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Byte-wise Write using Strobe", test_num);
            reset_dut();


            addr_dmem_ram_i = 32'h4;
            wr_data_dmem_ram_i = 32'h00000000;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b1111;
            @(posedge clk);
            #1;



            addr_dmem_ram_i = 32'h4;
            wr_data_dmem_ram_i = 32'hAABBCCDD;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b0110;
            @(posedge clk);
            #1;


            wr_en_dmem_ram_i = 1'b0;
            addr_dmem_ram_i = 32'h4;
            #2;

            #1;


            check_outputs(32'h00BBCC00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification", test_num);
            reset_dut();


            addr_dmem_ram_i = 32'h8;
            wr_data_dmem_ram_i = 32'h55555555;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b1111;
            @(posedge clk);
            #1;


            addr_dmem_ram_i = 32'h8;
            wr_data_dmem_ram_i = 32'hAAAAAAAA;
            wr_en_dmem_ram_i = 1'b0;
            wr_strb_dmem_ram_i = 4'b1111;
            @(posedge clk);
            #1;


            addr_dmem_ram_i = 32'h8;
            #2;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Isolation", test_num);
            reset_dut();


            addr_dmem_ram_i = 32'hC;
            wr_data_dmem_ram_i = 32'h11111111;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b1111;
            @(posedge clk);
            #1;


            addr_dmem_ram_i = 32'h10;
            wr_data_dmem_ram_i = 32'h22222222;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b1111;
            @(posedge clk);
            #1;


            wr_en_dmem_ram_i = 1'b0;
            addr_dmem_ram_i = 32'hC;
            #2;
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Byte Strobe Test", test_num);
            reset_dut();


            addr_dmem_ram_i = 32'h14;
            wr_data_dmem_ram_i = 32'h0;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b1111;
            @(posedge clk);
            #1;


            addr_dmem_ram_i = 32'h14;
            wr_data_dmem_ram_i = 32'hFF000000;
            wr_en_dmem_ram_i = 1'b1;
            wr_strb_dmem_ram_i = 4'b0001;


            @(posedge clk);
            #1;

            wr_en_dmem_ram_i = 1'b0;
            addr_dmem_ram_i = 32'h14;
            #2;
            #1;

            check_outputs(32'hFF000000);
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
        input [31:0] expected_read_data_dmem_ram_o;
        begin
            if (expected_read_data_dmem_ram_o === (expected_read_data_dmem_ram_o ^ read_data_dmem_ram_o ^ expected_read_data_dmem_ram_o)) begin
                $display("PASS");
                $display("  Outputs: read_data_dmem_ram_o=%h",
                         read_data_dmem_ram_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data_dmem_ram_o=%h",
                         expected_read_data_dmem_ram_o);
                $display("  Got:      read_data_dmem_ram_o=%h",
                         read_data_dmem_ram_o);
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
        $dumpvars(0,addr_dmem_ram_i, clk, wr_data_dmem_ram_i, wr_en_dmem_ram_i, wr_strb_dmem_ram_i, read_data_dmem_ram_o);
    end

endmodule
