`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] adr;
    reg clk;
    reg [7:0] d_in;
    reg we;
    wire [7:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .adr(adr),
        .clk(clk),
        .d_in(d_in),
        .we(we),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            @(posedge clk);
            we = 1;
            for (i = 0; i < 8; i = i + 1) begin
                adr = i;
                d_in = 8'h00;
                @(posedge clk);
            end
            we = 0;
            adr = 0;
            d_in = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read (Addr 0)");
            test_num = 1;
            reset_dut();

            @(posedge clk);
            we = 1;
            adr = 3'd0;
            d_in = 8'hAA;

            @(posedge clk);
            we = 0;
            adr = 3'd0;

            #5;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Boundary Address Write and Read (Addr 7)");
            test_num = 2;
            reset_dut();

            @(posedge clk);
            we = 1;
            adr = 3'd7;
            d_in = 8'h55;

            @(posedge clk);
            we = 0;
            adr = 3'd7;

            #5;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify Write Enable signal");
            test_num = 3;
            reset_dut();


            @(posedge clk);
            we = 1;
            adr = 3'd4;
            d_in = 8'h12;


            @(posedge clk);
            we = 0;
            adr = 3'd4;
            d_in = 8'hFF;

            @(posedge clk);
            adr = 3'd4;

            #5;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting data");
            test_num = 4;
            reset_dut();

            @(posedge clk);
            we = 1;
            adr = 3'd2;
            d_in = 8'hCC;

            @(posedge clk);
            we = 1;
            adr = 3'd2;
            d_in = 8'h33;

            @(posedge clk);
            we = 0;
            adr = 3'd2;

            #5;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Address Isolation check");
            test_num = 5;
            reset_dut();

            @(posedge clk);
            we = 1;
            adr = 3'd1;
            d_in = 8'hFE;

            @(posedge clk);
            we = 1;
            adr = 3'd6;
            d_in = 8'hCA;

            @(posedge clk);
            we = 0;
            adr = 3'd1;

            #5;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        input [7:0] expected_d_out;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
        $dumpvars(0,adr, clk, d_in, we, d_out);
    end

endmodule
