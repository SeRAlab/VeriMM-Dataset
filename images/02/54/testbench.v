`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg GIE;
    reg [3:0] IRQ;
    reg clk;
    reg rst;
    wire INT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .GIE(GIE),
        .IRQ(IRQ),
        .clk(clk),
        .rst(rst),
        .INT(INT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            GIE = 0;
            IRQ = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State (GIE=0, IRQ=0)", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: GIE Dominance (GIE=0, IRQ=4'b1111)", test_num);
            reset_dut();
            GIE = 0;
            IRQ = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: IRQ0 Asserted (GIE=1, IRQ=4'b0001)", test_num);
            reset_dut();
            GIE = 1;
            IRQ = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: IRQ3 Asserted (GIE=1, IRQ=4'b1000)", test_num);
            reset_dut();
            GIE = 1;
            IRQ = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Multiple IRQs Asserted (GIE=1, IRQ=4'b1011)", test_num);
            reset_dut();
            GIE = 1;
            IRQ = 4'b1011;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: GIE Enable/Disable Toggle", test_num);
            reset_dut();
            IRQ = 4'b0010;
            GIE = 1;
            @(posedge clk);
            #1;
            if (INT !== 1'b1) begin
                $display("FAIL: INT should be high when GIE=1");
                fail_count = fail_count + 1;
            end else begin
                GIE = 0;
                @(posedge clk);
                #1 #1;
 check_outputs(1'b0);
            end
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: IRQ Deassertion (GIE=1, IRQ 1->0)", test_num);
            reset_dut();
            GIE = 1;
            IRQ = 4'b0100;
            @(posedge clk);
            #1;
            IRQ = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("interrupt_controller Testbench");
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
        input expected_INT;
        begin
            if (expected_INT === (expected_INT ^ INT ^ expected_INT)) begin
                $display("PASS");
                $display("  Outputs: INT=%b",
                         INT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INT=%b",
                         expected_INT);
                $display("  Got:      INT=%b",
                         INT);
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
        $dumpvars(0,GIE, IRQ, clk, rst, INT);
    end

endmodule
