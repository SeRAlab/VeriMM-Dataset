`timescale 1ns/1ps

module add8_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg enable;
    reg reset;
    wire [7:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add8 dut (
        .a(a),
        .b(b),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            enable = 0;
            a = 8'h00;
            b = 8'h00;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying reset results in output 0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simple addition (15 + 25)", test_num);
            @(posedge clk);
            a = 8'd15;
            b = 8'd25;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify enable logic (enable=0 should not update c)", test_num);

            @(posedge clk);
            a = 8'd10;
            b = 8'd10;
            enable = 1;
            @(posedge clk);
            #1;


            @(posedge clk);
            a = 8'd50;
            b = 8'd50;
            enable = 0;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'd20);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 8-bit overflow (200 + 100)", test_num);
            @(posedge clk);
            a = 8'd200;
            b = 8'd100;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values (255 + 255)", test_num);
            @(posedge clk);
            a = 8'hFF;
            b = 8'hFF;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over enable", test_num);
            @(posedge clk);
            a = 8'd100;
            b = 8'd50;
            enable = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition", test_num);
            @(posedge clk);
            a = 8'd0;
            b = 8'd0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add8 Testbench");
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
        input [7:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,a, b, clk, enable, reset, c);
    end

endmodule
