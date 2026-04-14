`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg a2;
    reg a3;
    reg a4;
    reg a5;
    reg a6;
    reg a7;
    reg b0;
    reg b1;
    reg b2;
    reg b3;
    reg b4;
    reg b5;
    reg b6;
    reg b7;
    wire car1;
    wire car2;
    wire car3;
    wire car4;
    wire car5;
    wire car6;
    wire car7;
    wire car8;
    wire s0;
    wire s1;
    wire s2;
    wire s3;
    wire s4;
    wire s5;
    wire s6;
    wire s7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .b4(b4),
        .b5(b5),
        .b6(b6),
        .b7(b7),
        .car1(car1),
        .car2(car2),
        .car3(car3),
        .car4(car4),
        .car5(car5),
        .car6(car6),
        .car7(car7),
        .car8(car8),
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: 0 + 0", test_num);
            set_inputs(8'h00, 8'h00);

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: 1 + 0", test_num);
            set_inputs(8'h01, 8'h00);

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: 1 + 1", test_num);
            set_inputs(8'h01, 8'h01);

            #1;


            check_outputs(1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: 127 + 1", test_num);
            set_inputs(8'h7F, 8'h01);



            #1;




            check_outputs(1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: 255 + 1", test_num);
            set_inputs(8'hFF, 8'h01);



            #1;




            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: 0xAA + 0x55", test_num);
            set_inputs(8'hAA, 8'h55);


            #1;



            check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: 0x55 + 0x55", test_num);
            set_inputs(8'h55, 8'h55);




            #1;





            check_outputs(1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: 0xFF + 0xFF", test_num);
            set_inputs(8'hFF, 8'hFF);





            #1;






            check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_car1;
        input expected_car2;
        input expected_car3;
        input expected_car4;
        input expected_car5;
        input expected_car6;
        input expected_car7;
        input expected_car8;
        input expected_s0;
        input expected_s1;
        input expected_s2;
        input expected_s3;
        input expected_s4;
        input expected_s5;
        input expected_s6;
        input expected_s7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_car1 === (expected_car1 ^ car1 ^ expected_car1) &&
                expected_car2 === (expected_car2 ^ car2 ^ expected_car2) &&
                expected_car3 === (expected_car3 ^ car3 ^ expected_car3) &&
                expected_car4 === (expected_car4 ^ car4 ^ expected_car4) &&
                expected_car5 === (expected_car5 ^ car5 ^ expected_car5) &&
                expected_car6 === (expected_car6 ^ car6 ^ expected_car6) &&
                expected_car7 === (expected_car7 ^ car7 ^ expected_car7) &&
                expected_car8 === (expected_car8 ^ car8 ^ expected_car8) &&
                expected_s0 === (expected_s0 ^ s0 ^ expected_s0) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_s3 === (expected_s3 ^ s3 ^ expected_s3) &&
                expected_s4 === (expected_s4 ^ s4 ^ expected_s4) &&
                expected_s5 === (expected_s5 ^ s5 ^ expected_s5) &&
                expected_s6 === (expected_s6 ^ s6 ^ expected_s6) &&
                expected_s7 === (expected_s7 ^ s7 ^ expected_s7)) begin
                $display("PASS");
                $display("  Outputs: car1=%b, car2=%b, car3=%b, car4=%b, car5=%b, car6=%b, car7=%b, car8=%b, s0=%b, s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b",
                         car1, car2, car3, car4, car5, car6, car7, car8, s0, s1, s2, s3, s4, s5, s6, s7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: car1=%b, car2=%b, car3=%b, car4=%b, car5=%b, car6=%b, car7=%b, car8=%b, s0=%b, s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b",
                         expected_car1, expected_car2, expected_car3, expected_car4, expected_car5, expected_car6, expected_car7, expected_car8, expected_s0, expected_s1, expected_s2, expected_s3, expected_s4, expected_s5, expected_s6, expected_s7);
                $display("  Got:      car1=%b, car2=%b, car3=%b, car4=%b, car5=%b, car6=%b, car7=%b, car8=%b, s0=%b, s1=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b",
                         car1, car2, car3, car4, car5, car6, car7, car8, s0, s1, s2, s3, s4, s5, s6, s7);
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
