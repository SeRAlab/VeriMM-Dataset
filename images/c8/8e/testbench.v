`timescale 1ns/1ps

module concat_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] In0;
    reg [1:0] In1;
    reg clk;
    wire [9:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    concat dut (
        .In0(In0),
        .In1(In1),
        .clk(clk),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            In0 = 8'h0;
            In1 = 2'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            In1 = 2'b00;
            In0 = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            In1 = 2'b11;
            In0 = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern A", test_num);
            reset_dut();
            In1 = 2'b10;
            In0 = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'b10_10101010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern B", test_num);
            reset_dut();
            In1 = 2'b01;
            In0 = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'b01_01010101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - High In1, Low In0", test_num);
            reset_dut();
            In1 = 2'b11;
            In0 = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h300);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary - Low In1, High In0", test_num);
            reset_dut();
            In1 = 2'b00;
            In0 = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h0FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Bit Verification", test_num);
            reset_dut();
            In1 = 2'b10;
            In0 = 8'h81;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'b10_10000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("concat Testbench");
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
        input [9:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,In0, In1, clk, dout);
    end

endmodule
