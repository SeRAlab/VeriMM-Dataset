`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg wr_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 3'b0;
            data_in = 8'b0;
            wr_en = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Write and Read at Address 0");


            addr = 3'd0;
            data_in = 8'hAA;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            addr = 3'd0;
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Write and Read at Address 7");


            addr = 3'd7;
            data_in = 8'h55;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            addr = 3'd7;
            #2;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Verify wr_en low prevents writing");


            addr = 3'd2;
            data_in = 8'hFF;
            wr_en = 0;
            @(posedge clk);
            #1;




            addr = 3'd2;
            #2;
            if (data_out !== 8'hFF) begin
                pass_count = pass_count + 1;
                $display("PASS: Data was not written.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Data was written despite wr_en being low.");
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Multi-Address Integrity (Addr 1 and Addr 4)");


            addr = 3'd1;
            data_in = 8'h11;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 3'd4;
            data_in = 8'h44;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            addr = 3'd1;
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Overwriting data at Address 3");


            addr = 3'd3;
            data_in = 8'hCC;
            wr_en = 1;
            @(posedge clk);
            #1;


            data_in = 8'h33;
            @(posedge clk);
            #1;


            wr_en = 0;
            addr = 3'd3;
            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Data persistence when data_in changes but wr_en is low");


            addr = 3'd5;
            data_in = 8'hBE;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            data_in = 8'h00;
            addr = 3'd5;
            #2;


            #1;



            check_outputs(8'hBE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        $dumpvars(0,addr, clk, data_in, wr_en, data_out);
    end

endmodule
