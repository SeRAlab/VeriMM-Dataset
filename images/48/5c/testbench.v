`timescale 1ns/1ps

module mux_4to1_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d0;
    reg [3:0] d1;
    reg [3:0] d2;
    reg [3:0] d3;
    reg [1:0] sel;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1_4bit dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select d0", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h0; d3 = 4'hF;
        sel = 2'b00;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select d1", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h0; d3 = 4'hF;
        sel = 2'b01;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select d2", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h0; d3 = 4'hF;
        sel = 2'b10;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select d3", test_num);
        d0 = 4'hA; d1 = 4'h5; d2 = 4'h0; d3 = 4'hF;
        sel = 2'b11;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All inputs same", test_num);
        d0 = 4'hC; d1 = 4'hC; d2 = 4'hC; d3 = 4'hC;
        sel = 2'b10;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Bit pattern 4'h1, 4'h2, 4'h4, 4'h8", test_num);
        d0 = 4'h1; d1 = 4'h2; d2 = 4'h4; d3 = 4'h8;

        sel = 2'b00; #1;
        #1;

        check_outputs(4'h1);

        sel = 2'b01; #1;
        #1;

        check_outputs(4'h2);

        sel = 2'b10; #1;
        #1;

        check_outputs(4'h4);

        sel = 2'b11; #1;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: All Zeros", test_num);
        d0 = 4'b0000; d1 = 4'b0000; d2 = 4'b0000; d3 = 4'b0000;
        sel = 2'b11;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: All Ones", test_num);
        d0 = 4'b1111; d1 = 4'b1111; d2 = 4'b1111; d3 = 4'b1111;
        sel = 2'b01;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1_4bit Testbench");
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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

endmodule
