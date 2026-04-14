`timescale 1ns/1ps

module sram_cell_tb;

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
    sram_cell dut (
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
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Basic Write and Read at Address 0");


            @(posedge clk);
            addr = 3'd0;
            data_in = 8'hA5;
            we = 1;

            @(posedge clk);
            we = 0;

            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Basic Write and Read at Address 7");


            @(posedge clk);
            addr = 3'd7;
            data_in = 8'h5A;
            we = 1;

            @(posedge clk);
            we = 0;

            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Overwrite data at Address 3");


            @(posedge clk);
            addr = 3'd3;
            data_in = 8'h11;
            we = 1;


            @(posedge clk);
            data_in = 8'h99;

            @(posedge clk);
            we = 0;

            #2;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Verify Write Enable signal (we=0 should not update memory)");


            @(posedge clk);
            addr = 3'd4;
            data_in = 8'hCC;
            we = 1;


            @(posedge clk);
            we = 0;
            data_in = 8'h00;

            @(posedge clk);

            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Address Isolation (Addr 1 vs Addr 2)");


            @(posedge clk);
            addr = 3'd1;
            data_in = 8'hBB;
            we = 1;


            @(posedge clk);
            addr = 3'd2;
            data_in = 8'hEE;

            @(posedge clk);
            we = 0;
            addr = 3'd1;

            #2;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Data integrity with all bits high (0xFF)");

            @(posedge clk);
            addr = 3'd5;
            data_in = 8'hFF;
            we = 1;

            @(posedge clk);
            we = 0;

            #2;
            #1;

            check_outputs(8'hFF);
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
