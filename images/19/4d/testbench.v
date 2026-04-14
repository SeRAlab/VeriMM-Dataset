`timescale 1ns/1ps

module deserializer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] din;
    reg rst;
    wire [15:0] dout;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer_16bit dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 2'b00;
            @(posedge clk);
            #1;
            rst = 0;
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat (8) begin
                din = 2'b11;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat (8) begin
                din = 2'b00;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat (8) begin
                din = 2'b01;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(16'h5555, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            din = 2'b10; @(posedge clk); #1;
            din = 2'b11; @(posedge clk); #1;
            din = 2'b00; @(posedge clk); #1;
            din = 2'b01; @(posedge clk); #1;
            din = 2'b10; @(posedge clk); #1;
            din = 2'b11; @(posedge clk); #1;
            din = 2'b00; @(posedge clk); #1;
            din = 2'b01; @(posedge clk); #1;

            #1;


            check_outputs(16'hB1B1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            repeat (4) begin
                din = 2'b11;
                @(posedge clk);
                #1;
            end


            reset_dut();


            repeat (8) begin
                din = 2'b10;
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat (7) begin
                din = 2'b11;
                @(posedge clk);
                #1;
            end

            if (valid === 1'b0) begin
                $display("PASS: test_num %0d (Valid is low as expected)", test_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: test_num %0d (Valid high too early)", test_num);
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer_16bit Testbench");
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
        input [15:0] expected_dout;
        input expected_valid;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, valid=%b",
                         dout, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, valid=%b",
                         expected_dout, expected_valid);
                $display("  Got:      dout=%h, valid=%b",
                         dout, valid);
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
        $dumpvars(0,clk, din, rst, dout, valid);
    end

endmodule
