`timescale 1ns/1ps

module fixed_priority_arbiter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [4:0] req;
    reg rst_n;
    wire [4:0] gnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_priority_arbiter dut (
        .clk(clk),
        .enable(enable),
        .req(req),
        .rst_n(rst_n),
        .gnt(gnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable = 0;
            req = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            req = 5'b00001;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            req = 5'b10000;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            req = 5'b00011;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            req = 5'b11111;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            req = 5'b11000;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b01000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            req = 5'b11111;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            req = 5'b00000;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            req = 5'b00100;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00100);
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
        input [4:0] expected_gnt;
        begin
            if (expected_gnt === (expected_gnt ^ gnt ^ expected_gnt)) begin
                $display("PASS");
                $display("  Outputs: gnt=%h",
                         gnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gnt=%h",
                         expected_gnt);
                $display("  Got:      gnt=%h",
                         gnt);
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
        $dumpvars(0,clk, enable, req, rst_n, gnt);
    end

endmodule
