`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Writing 0xA5 to Address 0...");
            reset_dut();
            test_num = 1;


            addr = 3'd0;
            data_in = 8'hA5;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Writing 0x5A to Address 7...");
            reset_dut();
            test_num = 2;


            addr = 3'd7;
            data_in = 8'h5A;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Overwriting Address 3 (0x11 then 0x22)...");
            reset_dut();
            test_num = 3;


            addr = 3'd3;
            data_in = 8'h11;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 8'h22;
            @(posedge clk);
            #1;
            we = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Verifying that we=0 prevents writing...");
            reset_dut();
            test_num = 4;


            addr = 3'd4;
            data_in = 8'hCC;
            we = 1;
            @(posedge clk);
            #1;


            data_in = 8'hDD;
            we = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase005: Writing unique values to all addresses, checking Address 5...");
            reset_dut();
            test_num = 5;


            for(i = 0; i < 8; i = i + 1) begin
                addr = i;
                data_in = i + 8'h10;
                we = 1;
                @(posedge clk);
                #1;
            end

            we = 0;

            addr = 3'd5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
