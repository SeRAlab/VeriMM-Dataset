`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [31:0] data_i;
    reg reset;
    reg rw;
    reg strobe;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_i(data_i),
        .reset(reset),
        .rw(rw),
        .strobe(strobe),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            strobe = 0;
            rw = 0;
            addr = 0;
            data_i = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h0;
            data_i = 32'hAAAA5555;
            rw = 1;
            strobe = 1;
            @(posedge clk);
            strobe = 0;


            @(posedge clk);
            rw = 0;
            strobe = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reset clears registers", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h1;
            data_i = 32'h12345678;
            rw = 1;
            strobe = 1;
            @(posedge clk);
            strobe = 0;


            reset_dut();


            @(posedge clk);
            addr = 32'h1;
            rw = 0;
            strobe = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple address isolation", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h2;
            data_i = 32'hBEEFCAFE;
            rw = 1;
            strobe = 1;
            @(posedge clk);


            addr = 32'h3;
            data_i = 32'hDEADBEEF;
            @(posedge clk);
            strobe = 0;


            @(posedge clk);
            addr = 32'h2;
            rw = 0;
            strobe = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hBEEFCAFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Strobe control check", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h4;
            data_i = 32'h5555AAAA;
            rw = 1;
            strobe = 0;
            @(posedge clk);


            @(posedge clk);
            rw = 0;
            strobe = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Register Overwrite", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h5;
            data_i = 32'h11111111;
            rw = 1;
            strobe = 1;
            @(posedge clk);


            data_i = 32'h22222222;
            @(posedge clk);
            strobe = 0;


            @(posedge clk);
            rw = 0;
            strobe = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h22222222);
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
        $dumpvars(0,addr, clk, data_i, reset, rw, strobe, data_o);
    end

endmodule
