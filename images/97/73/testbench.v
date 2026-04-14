`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_i;
    reg clk;
    reg [31:0] data_i;
    reg we_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk(clk),
        .data_i(data_i),
        .we_i(we_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr_i = 32'b0;
        data_i = 32'b0;
        we_i = 1'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Write and Read (Address 0x5)", test_num);

        addr_i = 32'h0000_0005;
        data_i = 32'hA5A5_A5A5;
        we_i = 1'b1;
        @(posedge clk);
        #1;

        we_i = 1'b0;
        addr_i = 32'h0000_0005;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5_A5A5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Invalid Address Access (Bit 12 is 1)", test_num);
        addr_i = 32'h0000_1005;
        data_i = 32'hCAFEBABE;
        we_i = 1'b1;
        @(posedge clk);
        #1;
        we_i = 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Invalid Address Access (Bit 15 is 1)", test_num);
        addr_i = 32'h0000_8000;
        data_i = 32'hDEADBEEF;
        we_i = 1'b1;
        @(posedge clk);
        #1;
        we_i = 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Boundary Address 1023", test_num);
        addr_i = 32'd1023;
        data_i = 32'h11223344;
        we_i = 1'b1;
        @(posedge clk);
        #1;
        we_i = 1'b0;
        addr_i = 32'd1023;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h11223344);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Boundary Address 0", test_num);
        addr_i = 32'd0;
        data_i = 32'h88776655;
        we_i = 1'b1;
        @(posedge clk);
        #1;
        we_i = 1'b0;
        addr_i = 32'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h88776655);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: High bits set but bits 15:12 are zero", test_num);
        addr_i = 32'h0001_000A;
        data_i = 32'h55AA55AA;
        we_i = 1'b1;
        @(posedge clk);
        #1;
        we_i = 1'b0;
        addr_i = 32'h0001_000A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h55AA55AA);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Write Enable Low Check", test_num);

        addr_i = 32'h0000_0010;
        data_i = 32'hBEEFCAFE;
        we_i = 1'b1;
        @(posedge clk);
        #1;

        data_i = 32'h0;
        we_i = 1'b0;
        @(posedge clk);
        #1;

        addr_i = 32'h0000_0010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hBEEFCAFE);
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
        input [31:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,addr_i, clk, data_i, we_i, data_o);
    end

endmodule
