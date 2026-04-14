`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg [7:0] u;
    reg [7:0] v;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .u(u),
        .v(v),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner Case (u=0, v=0)", test_num);
            A = 8'd50; B = 8'd100; C = 8'd150; D = 8'd200;
            u = 8'd0; v = 8'd0;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Uniform Pixels (All 128)", test_num);
            A = 8'd128; B = 8'd128; C = 8'd128; D = 8'd128;
            u = 8'd64; v = 8'd192;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Center Midpoint (u=128, v=128)", test_num);
            A = 8'd0; B = 8'd100; C = 8'd200; D = 8'd255;
            u = 8'd128; v = 8'd128;


            #1;



            check_outputs(8'd138);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Horizontal Interpolation (v=0)", test_num);
            A = 8'd10; B = 8'd210; C = 8'd50; D = 8'd100;
            u = 8'd128; v = 8'd0;

            #1;


            check_outputs(8'd110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertical Interpolation (u=0)", test_num);
            A = 8'd10; B = 8'd50; C = 8'd210; D = 8'd100;
            u = 8'd0; v = 8'd128;

            #1;


            check_outputs(8'd110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Near Bottom-Right Corner (u=255, v=255)", test_num);
            A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd255;
            u = 8'd255; v = 8'd255;

            #1;


            check_outputs(8'd253);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: General Interpolation", test_num);
            A = 8'd10; B = 8'd110; C = 8'd210; D = 8'd50;
            u = 8'd64; v = 8'd192;




            #1;





            check_outputs(8'd136);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Inputs", test_num);
            A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd0;
            u = 8'd255; v = 8'd255;
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
        $display("bilinear_interpolation Testbench");
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
        input [7:0] expected_out;
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
