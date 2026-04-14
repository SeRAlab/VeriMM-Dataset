`timescale 1ns/1ps

module sync_ram_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_ram dut (
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
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read at Address 0", test_num);
            reset_dut();


            addr = 8'h00; data_in = 8'hAA; we = 1;
            @(posedge clk); #1;


            we = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Check - Address 15", test_num);
            reset_dut();


            addr = 8'h0F; data_in = 8'h55; we = 1;
            @(posedge clk); #1;


            we = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable (WE) Verification", test_num);
            reset_dut();


            addr = 8'h05; data_in = 8'hB1; we = 1;
            @(posedge clk); #1;


            we = 0; data_in = 8'hFF;
            @(posedge clk); #1;


            @(posedge clk); #1;
            #1;

            check_outputs(8'hB1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Memory Independence Check", test_num);
            reset_dut();


            addr = 8'h01; data_in = 8'h11; we = 1;
            @(posedge clk); #1;


            addr = 8'h02; data_in = 8'h22; we = 1;
            @(posedge clk); #1;


            addr = 8'h01; we = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwriting Data at Address 7", test_num);
            reset_dut();


            addr = 8'h07; data_in = 8'hC0; we = 1;
            @(posedge clk); #1;


            data_in = 8'hDE;
            @(posedge clk); #1;


            we = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hDE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_ram Testbench");
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
