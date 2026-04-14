`timescale 1ns/1ps

module my_mac_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [31:0] din0;
    reg [31:0] din1;
    reg reset;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_mac dut (
        .ce(ce),
        .clk(clk),
        .din0(din0),
        .din1(din1),
        .reset(reset),
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
        ce = 0;
        din0 = 0;
        din1 = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Basic Accumulation (5 * 10)", test_num);
        ce = 1;
        din0 = 32'd5;
        din1 = 32'd10;
        @(posedge clk);
        #1;
        ce = 0;
        #1;

        check_outputs(32'd50);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Multiple Sequential Accumulations", test_num);
        ce = 1;

        din0 = 32'd2; din1 = 32'd3;
        @(posedge clk); #1;

        din0 = 32'd4; din1 = 32'd5;
        @(posedge clk); #1;

        din0 = 32'd10; din1 = 32'd10;
        @(posedge clk); #1;

        ce = 0;
        #1;

        check_outputs(32'd126);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Clock Enable (ce) Verification", test_num);

        ce = 1;
        din0 = 32'd10; din1 = 32'd10;
        @(posedge clk); #1;

        ce = 0;
        din0 = 32'd5; din1 = 32'd5;
        @(posedge clk); #1;

        #1;


        check_outputs(32'd100);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Zero", test_num);

        ce = 1;
        din0 = 32'd10; din1 = 32'd10;
        @(posedge clk); #1;

        din0 = 32'd5; din1 = 32'd0;
        @(posedge clk); #1;

        ce = 0;
        #1;

        check_outputs(32'd100);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: 32-bit Overflow Wrap-around", test_num);

        ce = 1;
        din0 = 32'hFFFFFFFF; din1 = 32'd1;
        @(posedge clk); #1;

        din0 = 32'd1; din1 = 32'd1;
        @(posedge clk); #1;

        ce = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Large Value Multiplication", test_num);

        ce = 1;
        din0 = 32'h00001000; din1 = 32'h00001000;
        @(posedge clk); #1;

        ce = 0;
        #1;

        check_outputs(32'h01000000);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Reset Mid-operation", test_num);

        ce = 1;
        din0 = 32'd20; din1 = 32'd5;
        @(posedge clk); #1;

        reset = 1;
        @(posedge clk); #1;
        reset = 0;

        #1;


        check_outputs(32'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("my_mac Testbench");
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
        input [31:0] expected_dout;
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
        $dumpvars(0,ce, clk, din0, din1, reset, dout);
    end

endmodule
