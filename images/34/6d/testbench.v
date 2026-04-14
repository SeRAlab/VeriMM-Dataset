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
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros (0000h)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                din = 2'b00;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones (FFFFh)", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                din = 2'b11;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits (AAAAh)", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                din = 2'b10;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits (5555h)", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                din = 2'b01;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(16'h5555, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pattern ACE0h", test_num);
            reset_dut();

            din = 2'b10; @(posedge clk);
            din = 2'b10; @(posedge clk);
            din = 2'b11; @(posedge clk);
            din = 2'b00; @(posedge clk);
            din = 2'b11; @(posedge clk);
            din = 2'b10; @(posedge clk);
            din = 2'b00; @(posedge clk);
            din = 2'b00; @(posedge clk);
            #1;
            #1;

            check_outputs(16'hACE0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pattern 1234h", test_num);
            reset_dut();

            din = 2'b00; @(posedge clk);
            din = 2'b01; @(posedge clk);
            din = 2'b00; @(posedge clk);
            din = 2'b10; @(posedge clk);
            din = 2'b00; @(posedge clk);
            din = 2'b11; @(posedge clk);
            din = 2'b01; @(posedge clk);
            din = 2'b00; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-stream Reset Check", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                din = 2'b11;
                @(posedge clk);
            end


            rst = 1;
            @(posedge clk);
            rst = 0;


            for (i = 0; i < 8; i = i + 1) begin
                din = 2'b01;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(16'h5555, 1'b1);
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
