`timescale 1ns/1ps

module sram_cell_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell_8bit dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .re(re),
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
            addr = 3'b000;
            data_in = 8'h00;
            re = 1'b0;
            we = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Write 8'hA5 to Addr 0 and Read it back");


            @(posedge clk);
            addr = 3'd0;
            data_in = 8'hA5;
            we = 1'b1;
            re = 1'b0;

            @(posedge clk);
            we = 1'b0;


            @(posedge clk);
            re = 1'b1;
            #2;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Write 8'h5A to Addr 7 and Read it back");


            @(posedge clk);
            addr = 3'd7;
            data_in = 8'h5A;
            we = 1'b1;
            re = 1'b0;

            @(posedge clk);
            we = 1'b0;


            @(posedge clk);
            re = 1'b1;
            #2;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Verify WE signal (attempt write when WE=0)");


            @(posedge clk);
            addr = 3'd2;
            data_in = 8'hFF;
            we = 1'b1;

            @(posedge clk);

            we = 1'b0;
            data_in = 8'h00;

            @(posedge clk);

            re = 1'b1;
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Verify data independence across different addresses");


            @(posedge clk);
            addr = 3'd1; data_in = 8'h11; we = 1'b1;
            @(posedge clk);

            addr = 3'd2; data_in = 8'h22; we = 1'b1;
            @(posedge clk);
            we = 1'b0;


            addr = 3'd1;
            re = 1'b1;
            #2;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Verify RE signal (check output when RE=0)");


            @(posedge clk);
            addr = 3'd4;
            data_in = 8'hCC;
            we = 1'b1;

            @(posedge clk);
            we = 1'b0;
            re = 1'b0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell_8bit Testbench");
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
        $dumpvars(0,addr, clk, data_in, re, we, data_out);
    end

endmodule
