`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] IRQ;
    reg clk;
    reg rst;
    wire [3:0] ACK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .IRQ(IRQ),
        .clk(clk),
        .rst(rst),
        .ACK(ACK)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            IRQ = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            IRQ = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            IRQ = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            IRQ = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            IRQ = 4'b0100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            IRQ = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            IRQ = 4'b0011;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            IRQ = 4'b0110;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0010);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            IRQ = 4'b1100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0100);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            IRQ = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            IRQ = 4'b1110;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0010);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_ACK;
        begin
            if (expected_ACK === (expected_ACK ^ ACK ^ expected_ACK)) begin
                $display("PASS");
                $display("  Outputs: ACK=%h",
                         ACK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK=%h",
                         expected_ACK);
                $display("  Got:      ACK=%h",
                         ACK);
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
        $dumpvars(0,IRQ, clk, rst, ACK);
    end

endmodule
