`timescale 1ns/1ps

module bidirectional_data_port_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg [3:0] in;
    reg reset;
    wire [3:0] dout;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidirectional_data_port dut (
        .clk(clk),
        .dir(dir),
        .in(in),
        .reset(reset),
        .dout(dout),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            dir = 0;
            in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: dir=0, in=4'b1010");
            reset_dut();
            dir = 0;
            in = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b1010);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: dir=1, in=4'b1100");
            reset_dut();
            dir = 1;
            in = 4'b1100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0011, 4'b1100);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: dir=1, in=4'b1011");
            reset_dut();
            dir = 1;
            in = 4'b1011;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1101, 4'b1011);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: dir=1, in=4'b1000");
            reset_dut();
            dir = 1;
            in = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: dir=0, testing transparency");
            reset_dut();
            dir = 0;
            in = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0111);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: dir=1, boundary all ones");
            reset_dut();
            dir = 1;
            in = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: dir=1, boundary all zeros");
            reset_dut();
            dir = 1;
            in = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidirectional_data_port Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_dout;
        input [3:0] expected_out;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, out=%h",
                         dout, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, out=%h",
                         expected_dout, expected_out);
                $display("  Got:      dout=%h, out=%h",
                         dout, out);
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
        $dumpvars(0,clk, dir, in, reset, dout, out);
    end

endmodule
