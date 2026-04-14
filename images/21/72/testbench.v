`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg si;
    wire [7:0] so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .rst(rst),
        .si(si),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            si = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift single 1 through register", test_num);
            reset_dut();

            si = 1; @(posedge clk); #1;

            si = 0; repeat(7) begin @(posedge clk); #1; end

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Fill with all 1s", test_num);
            reset_dut();
            si = 1;
            repeat(8) begin @(posedge clk); #1; end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift in pattern 8'hA5", test_num);
            reset_dut();





            si = 1; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 1; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 1; @(posedge clk); #1;
            si = 0; @(posedge clk); #1;
            si = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Partial shift 4 bits (8'hF0)", test_num);
            reset_dut();
            si = 1;
            repeat(4) begin @(posedge clk); #1; end
            si = 0;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Shift in 8'hFF then shift out with 0s", test_num);
            reset_dut();
            si = 1; repeat(8) begin @(posedge clk); #1; end
            si = 0; repeat(8) begin @(posedge clk); #1; end
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_so;
        begin
            if (expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: so=%h",
                         so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: so=%h",
                         expected_so);
                $display("  Got:      so=%h",
                         so);
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
        $dumpvars(0,clk, rst, si, so);
    end

endmodule
