`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg reset;
    reg valid;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .valid(valid),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            data = 8'b10101010;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                din = data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(data);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            data = 8'b01010101;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                din = data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(data);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            data = 8'hFF;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                din = 1'b1;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(data);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            data = 8'h00;
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                din = 1'b0;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(data);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            data = 8'b10000000;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                din = data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(data);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] data;
        begin
            test_num = test_num + 1;
            data = 8'h3C;
            reset_dut();
            for (i = 7; i >= 0; i = i - 1) begin
                din = data[i];
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(data);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, reset, valid, dout);
    end

endmodule
