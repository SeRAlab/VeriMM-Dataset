`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] int_req;
    reg reset;
    wire [2:0] int_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .int_req(int_req),
        .reset(reset),
        .int_ack(int_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            int_req = 3'b000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Highest Priority Single Request (bit 0)", test_num);
            reset_dut();
            int_req = 3'b001;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle Priority Single Request (bit 1)", test_num);
            reset_dut();
            int_req = 3'b010;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lowest Priority Single Request (bit 2)", test_num);
            reset_dut();
            int_req = 3'b100;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Contention (0 and 1)", test_num);
            reset_dut();
            int_req = 3'b011;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Contention (1 and 2)", test_num);
            reset_dut();
            int_req = 3'b110;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Interrupts Active", test_num);
            reset_dut();
            int_req = 3'b111;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Requests", test_num);
            reset_dut();
            int_req = 3'b000;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Override during Request", test_num);
            reset_dut();
            int_req = 3'b111;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
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
        input [2:0] expected_int_ack;
        begin
            if (expected_int_ack === (expected_int_ack ^ int_ack ^ expected_int_ack)) begin
                $display("PASS");
                $display("  Outputs: int_ack=%h",
                         int_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_ack=%h",
                         expected_int_ack);
                $display("  Got:      int_ack=%h",
                         int_ack);
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
        $dumpvars(0,clk, int_req, reset, int_ack);
    end

endmodule
