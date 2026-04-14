`timescale 1ns/1ps

module single_port_ram_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clock;
    reg [7:0] data;
    reg we;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    single_port_ram dut (
        .addr(addr),
        .clock(clock),
        .data(data),
        .we(we),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            addr = 8'h0;
            data = 8'h0;
            we = 1'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initialization Check");
            reset_dut();
            test_num = 1;
            addr = 8'hA5;
            we = 1'b0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simple Write-then-Read");
            reset_dut();
            test_num = 2;

            addr = 8'h10;
            data = 8'h55;
            we = 1'b1;
            @(posedge clock);
            #1;

            we = 1'b0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Overwrite Check");
            reset_dut();
            test_num = 3;

            addr = 8'h20;
            data = 8'hAA;
            we = 1'b1;
            @(posedge clock);
            #1;

            data = 8'hBB;
            @(posedge clock);
            #1;

            we = 1'b0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiple Addresses");
            reset_dut();
            test_num = 4;

            addr = 8'h30; data = 8'h11; we = 1'b1;
            @(posedge clock); #1;

            addr = 8'h31; data = 8'h22; we = 1'b1;
            @(posedge clock); #1;

            addr = 8'h30; we = 1'b0;
            @(posedge clock); #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Address (0xFF)");
            reset_dut();
            test_num = 5;
            addr = 8'hFF;
            data = 8'hC3;
            we = 1'b1;
            @(posedge clock);
            #1;
            we = 1'b0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Boundary Address (0x00)");
            reset_dut();
            test_num = 6;
            addr = 8'h00;
            data = 8'h3C;
            we = 1'b1;
            @(posedge clock);
            #1;
            we = 1'b0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("single_port_ram Testbench");
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,addr, clock, data, we, out);
    end

endmodule
