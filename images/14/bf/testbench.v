`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [15:0] data_in;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write 0xABCD to Address 0x5 and Read back");
            reset_dut();


            address = 4'h5;
            data_in = 16'hABCD;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_enable = 0;
            address = 4'h5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Multiple Address Writes");
            reset_dut();


            address = 4'h0; data_in = 16'h1111; write_enable = 1;
            @(posedge clk); #1;


            address = 4'hF; data_in = 16'h2222; write_enable = 1;
            @(posedge clk); #1;


            write_enable = 0;
            address = 4'h0;
            @(posedge clk); #1;
            if (data_out !== 16'h1111) begin
                #1;

                check_outputs(16'h1111);
            end else begin

                address = 4'hF;
                @(posedge clk); #1;
                #1;

                check_outputs(16'h2222);
            end
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify Write Enable signal");
            reset_dut();


            address = 4'hA; data_in = 16'hAAAA; write_enable = 1;
            @(posedge clk); #1;


            address = 4'hA; data_in = 16'h5555; write_enable = 0;
            @(posedge clk); #1;


            address = 4'hA;
            @(posedge clk); #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data Pattern 0x0000 and 0xFFFF");
            reset_dut();


            address = 4'h1; data_in = 16'h0000; write_enable = 1;
            @(posedge clk); #1;


            address = 4'h2; data_in = 16'hFFFF; write_enable = 1;
            @(posedge clk); #1;


            write_enable = 0; address = 4'h1;
            @(posedge clk); #1;
            if (data_out !== 16'h0000) begin
                #1;

                check_outputs(16'h0000);
            end else begin

                address = 4'h2;
                @(posedge clk); #1;
                #1;

                check_outputs(16'hFFFF);
            end
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting existing data");
            reset_dut();


            address = 4'h7; data_in = 16'h1234; write_enable = 1;
            @(posedge clk); #1;


            address = 4'h7; data_in = 16'h5678; write_enable = 1;
            @(posedge clk); #1;


            write_enable = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, write_enable, data_out);
    end

endmodule
