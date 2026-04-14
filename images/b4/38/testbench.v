`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting data0", test_num);
            data0 = 4'hA; data1 = 4'h5; data2 = 4'h0; data3 = 4'hF;
            sel = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting data1", test_num);
            data0 = 4'hA; data1 = 4'h5; data2 = 4'h0; data3 = 4'hF;
            sel = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting data2", test_num);
            data0 = 4'hA; data1 = 4'h5; data2 = 4'h3; data3 = 4'hF;
            sel = 2'b10;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selecting data3", test_num);
            data0 = 4'hA; data1 = 4'h5; data2 = 4'h3; data3 = 4'hE;
            sel = 2'b11;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros check", test_num);
            data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0;
            sel = 2'b01;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones (0xF) check", test_num);
            data0 = 4'hF; data1 = 4'hF; data2 = 4'hF; data3 = 4'hF;
            sel = 2'b10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit pattern check", test_num);
            data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0100; data3 = 4'b1000;
            sel = 2'b11;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data change on active channel", test_num);
            sel = 2'b00;
            data0 = 4'h7;
            #2;
            data0 = 4'hB;
            #1;

            check_outputs(4'hB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
