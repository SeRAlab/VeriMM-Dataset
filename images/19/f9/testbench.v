`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] Req;
    reg clk;
    reg reset;
    wire [3:0] F_out;
    wire [3:0] V_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .Req(Req),
        .clk(clk),
        .reset(reset),
        .F_out(F_out),
        .V_out(V_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Req = 2'b00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Behavior (Lowest State)", test_num);
            reset_dut();

            #1;


            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Request Medium Level (01)", test_num);
            reset_dut();
            Req = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd2, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Request High Level (10)", test_num);
            reset_dut();
            Req = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd3, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Request Maximum Level (11)", test_num);
            reset_dut();
            Req = 2'b11;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd4, 4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Dynamic Transition Sequence", test_num);
            reset_dut();


            Req = 2'b10;
            @(posedge clk);
            #1;


            Req = 2'b00;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Persistence Check", test_num);
            reset_dut();
            Req = 2'b11;
            @(posedge clk);
            #2;

            Req = 2'b00;
            #1;

            #1;


            check_outputs(4'd4, 4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [3:0] expected_F_out;
        input [3:0] expected_V_out;
        begin
            if (expected_F_out === (expected_F_out ^ F_out ^ expected_F_out) &&
                expected_V_out === (expected_V_out ^ V_out ^ expected_V_out)) begin
                $display("PASS");
                $display("  Outputs: F_out=%h, V_out=%h",
                         F_out, V_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F_out=%h, V_out=%h",
                         expected_F_out, expected_V_out);
                $display("  Got:      F_out=%h, V_out=%h",
                         F_out, V_out);
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
        $dumpvars(0,Req, clk, reset, F_out, V_out);
    end

endmodule
