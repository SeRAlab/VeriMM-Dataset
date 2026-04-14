`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg reset;
    wire [7:0] data_out;
    wire [3:0] gnt;
    wire mem_write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .data_out(data_out),
        .gnt(gnt),
        .mem_write(mem_write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset State - No Requests");
            test_num = 1;
            reset_dut();
            req = 4'b0000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Single Request - Channel 0");
            test_num = 2;
            reset_dut();
            req = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 4'b0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Single Request - Channel 2");
            test_num = 3;
            reset_dut();
            req = 4'b0100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 4'b0100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Multi-Request Priority (Ch 0 & 1)");
            test_num = 4;
            reset_dut();
            req = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 4'b0001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Round-Robin Rotation (Ch 0 -> Ch 1)");
            test_num = 5;
            reset_dut();
            req = 4'b0011;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 4'b0010, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Full Cycle (Ch 0,1,2,3)");
            test_num = 6;
            reset_dut();
            req = 4'b1111;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 4'b1000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Wrap Around (Ch 3 -> Ch 0)");
            test_num = 7;
            reset_dut();
            req = 4'b1001;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 4'b0001, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Request De-assertion handling");
            test_num = 8;
            reset_dut();
            req = 4'b0011;
            @(posedge clk);
            req = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(data_out, 4'b0010, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_gnt;
        input expected_mem_write;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_gnt === (expected_gnt ^ gnt ^ expected_gnt) &&
                expected_mem_write === (expected_mem_write ^ mem_write ^ expected_mem_write)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, gnt=%h, mem_write=%b",
                         data_out, gnt, mem_write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, gnt=%h, mem_write=%b",
                         expected_data_out, expected_gnt, expected_mem_write);
                $display("  Got:      data_out=%h, gnt=%h, mem_write=%b",
                         data_out, gnt, mem_write);
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
        $dumpvars(0,clk, req, reset, data_out, gnt, mem_write);
    end

endmodule
