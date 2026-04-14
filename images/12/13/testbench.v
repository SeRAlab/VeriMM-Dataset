`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg [1:0] sel;
    wire mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .data(data),
        .sel(sel),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = 1;
            sel = 2'b00;
            data = 4'b1110;
            $display("Test %0d: sel=00, data=1110 (expecting data[0]=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            sel = 2'b00;
            data = 4'b0001;
            $display("Test %0d: sel=00, data=0001 (expecting data[0]=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            sel = 2'b01;
            data = 4'b1101;
            $display("Test %0d: sel=01, data=1101 (expecting data[1]=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            sel = 2'b01;
            data = 4'b0010;
            $display("Test %0d: sel=01, data=0010 (expecting data[1]=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            sel = 2'b10;
            data = 4'b1011;
            $display("Test %0d: sel=10, data=1011 (expecting data[2]=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            sel = 2'b10;
            data = 4'b0100;
            $display("Test %0d: sel=10, data=0100 (expecting data[2]=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            sel = 2'b11;
            data = 4'b0111;
            $display("Test %0d: sel=11, data=0111 (expecting data[3]=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            sel = 2'b11;
            data = 4'b1000;
            $display("Test %0d: sel=11, data=1000 (expecting data[3]=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            sel = 2'b00;
            data = 4'b1111;
            #5;
            data = 4'b0001;
            $display("Test %0d: sel=00, toggling non-selected inputs", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%b",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%b",
                         expected_mux_out);
                $display("  Got:      mux_out=%b",
                         mux_out);
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
