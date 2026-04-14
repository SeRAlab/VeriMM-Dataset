`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ACK;
    reg [3:0] IRQ;
    wire [3:0] IV;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .ACK(ACK),
        .IRQ(IRQ),
        .IV(IV)
    );

    // Clock generation (10ns period)
    initial begin
        ACK = 0;
        forever #5 ACK = ~ACK;
    end

        task reset_dut;

        begin
            IRQ = 4'b0000;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b0000;
            @(posedge ACK);
            #1;
            $display("Test %0d: No IRQ, ACK high", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b0001;
            @(posedge ACK);
            #1;
            $display("Test %0d: IRQ[0] active, ACK high", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b0010;
            @(posedge ACK);
            #1;
            $display("Test %0d: IRQ[1] active, ACK high", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b0100;
            @(posedge ACK);
            #1;
            $display("Test %0d: IRQ[2] active, ACK high", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b1000;
            @(posedge ACK);
            #1;
            $display("Test %0d: IRQ[3] active, ACK high", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b1001;
            @(posedge ACK);
            #1;
            $display("Test %0d: Priority Check (IRQ[3] > IRQ[0]), ACK high", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b0110;
            @(posedge ACK);
            #1;
            $display("Test %0d: Priority Check (IRQ[2] > IRQ[1]), ACK high", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b1111;
            @(posedge ACK);
            #1;
            $display("Test %0d: All IRQs active, ACK high", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            IRQ = 4'b1111;
            @(negedge ACK);
            #1;
            $display("Test %0d: IRQs active but ACK low", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge ACK);
            IRQ = 4'b0010;
            #1;
            $display("Test %0d: Changing IRQ while ACK is high (Part 1)", test_num);
            if (IV === 4'b0010) begin
                IRQ = 4'b1100;
                #1;
                $display("Test %0d: Changing IRQ while ACK is high (Part 2)", test_num);
                #1;

                check_outputs(4'b1000);
            end else begin
                #1;

                check_outputs(4'b0010);
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
        input [3:0] expected_IV;
        begin
            if (expected_IV === (expected_IV ^ IV ^ expected_IV)) begin
                $display("PASS");
                $display("  Outputs: IV=%h",
                         IV);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IV=%h",
                         expected_IV);
                $display("  Got:      IV=%h",
                         IV);
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
        $dumpvars(0,ACK, IRQ, IV);
    end

endmodule
