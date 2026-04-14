`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] irq_requests;
    reg reset;
    wire [2:0] irq_processed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq_requests(irq_requests),
        .reset(reset),
        .irq_processed(irq_processed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            irq_requests = 3'b000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Priority Only (Bit 0)", test_num);
            reset_dut();
            irq_requests = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium Priority Only (Bit 1)", test_num);
            reset_dut();
            irq_requests = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Priority Only (Bit 2)", test_num);
            reset_dut();
            irq_requests = 3'b100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Collision (High vs Low)", test_num);
            reset_dut();
            irq_requests = 3'b101;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Collision (Medium vs Low)", test_num);
            reset_dut();
            irq_requests = 3'b011;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Interrupts Active", test_num);
            reset_dut();
            irq_requests = 3'b111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Interrupts Active", test_num);
            reset_dut();
            irq_requests = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Priority Change Mid-stream", test_num);
            reset_dut();

            irq_requests = 3'b010;
            @(posedge clk);
            #1;

            irq_requests = 3'b110;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b100);
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
        input [2:0] expected_irq_processed;
        begin
            if (expected_irq_processed === (expected_irq_processed ^ irq_processed ^ expected_irq_processed)) begin
                $display("PASS");
                $display("  Outputs: irq_processed=%h",
                         irq_processed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq_processed=%h",
                         expected_irq_processed);
                $display("  Got:      irq_processed=%h",
                         irq_processed);
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
        $dumpvars(0,clk, irq_requests, reset, irq_processed);
    end

endmodule
