`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] request;
    reg rst_n;
    wire [3:0] grant;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .request(request),
        .rst_n(rst_n),
        .grant(grant),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            request = 4'b0000;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request 0 only", test_num);
            reset_dut();
            request = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request 1 only", test_num);
            reset_dut();
            request = 4'b0010;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request 2 only", test_num);
            reset_dut();
            request = 4'b0100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request 3 only", test_num);
            reset_dut();
            request = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Request 0 and 1", test_num);
            reset_dut();
            request = 4'b0011;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Request 1 and 2", test_num);
            reset_dut();
            request = 4'b0110;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Request 2 and 3", test_num);
            reset_dut();
            request = 4'b1100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0100, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Request 0 and 3", test_num);
            reset_dut();
            request = 4'b1001;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All requests active", test_num);
            reset_dut();
            request = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No requests active", test_num);
            reset_dut();
            request = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential request change", test_num);
            reset_dut();
            request = 4'b1000;
            @(posedge clk);
            request = 4'b0100;
            @(posedge clk);
            #1 #1;
 check_outputs(4'b0100, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_priority_arbiter Testbench");
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
        testcase011();
        
        
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
        input [3:0] expected_grant;
        input expected_valid;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: grant=%h, valid=%b",
                         grant, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h, valid=%b",
                         expected_grant, expected_valid);
                $display("  Got:      grant=%h, valid=%b",
                         grant, valid);
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
        $dumpvars(0,clk, request, rst_n, grant, valid);
    end

endmodule
