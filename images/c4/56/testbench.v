`timescale 1ns/1ps

module delay_reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    reg [31:0] In;
    reg Reset_1;
    reg enb_1_2000_0;
    reg reset;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    delay_reset_controller dut (
        .CLK_IN(CLK_IN),
        .In(In),
        .Reset_1(Reset_1),
        .enb_1_2000_0(enb_1_2000_0),
        .reset(reset),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

    begin
        reset = 1;
        enb_1_2000_0 = 0;
        Reset_1 = 0;
        In = 0;
        @(posedge CLK_IN);
        #1 reset = 0;
        @(posedge CLK_IN);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Delay Operation", test_num);
        reset_dut();

        enb_1_2000_0 = 1;
        Reset_1 = 0;
        In = 32'h12345678;

        @(posedge CLK_IN);
        #1;


        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Global Reset Functionality", test_num);
        reset_dut();

        enb_1_2000_0 = 1;
        In = 32'hAAAA5555;
        @(posedge CLK_IN);
        @(posedge CLK_IN);

        #1 reset = 1;
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Internal Reset_1 Functionality", test_num);
        reset_dut();

        enb_1_2000_0 = 1;
        Reset_1 = 0;
        In = 32'hBCDEBCDE;
        @(posedge CLK_IN);

        #1 Reset_1 = 1;
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable Signal Gating", test_num);
        reset_dut();


        enb_1_2000_0 = 1;
        In = 32'h77778888;
        @(posedge CLK_IN);
        @(posedge CLK_IN);


        #1 enb_1_2000_0 = 0;
        In = 32'hFFFFFFFF;
        @(posedge CLK_IN);
        @(posedge CLK_IN);
        #1;

        #1;


        check_outputs(32'h77778888);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Signed Negative Value Handling", test_num);
        reset_dut();

        enb_1_2000_0 = 1;
        Reset_1 = 0;
        In = -32'd500;

        @(posedge CLK_IN);
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(32'hFFFFFE0C);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset_1 Priority over Input", test_num);
        reset_dut();

        enb_1_2000_0 = 1;
        Reset_1 = 1;
        In = 32'hBBBBBBBB;

        @(posedge CLK_IN);
        @(posedge CLK_IN);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("delay_reset_controller Testbench");
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
        input [31:0] expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
        $dumpvars(0,CLK_IN, In, Reset_1, enb_1_2000_0, reset, Out);
    end

endmodule
